import Cocoa
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    var remote = false
    var window: NSWindow!
    func applicationDidFinishLaunching(_ n: Notification) {
        let config = WKWebViewConfiguration()
        // Native copy bridge: pages call window.webkit.messageHandlers.ftCopy.postMessage(text)
        config.userContentController.add(self, name: "ftCopy")
        let web = WKWebView(frame: .zero, configuration: config)
        web.navigationDelegate = self
        web.uiDelegate = self
        web.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15"
        web.setValue(false, forKey: "drawsBackground")
        window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 1200, height: 820),
                          styleMask: [.titled, .closable, .miniaturizable, .resizable],
                          backing: .buffered, defer: false)
        window.title = (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String) ?? "App"
        window.minSize = NSSize(width: 420, height: 500)
        window.contentView = web
        window.center()
        window.setFrameAutosaveName("MainWindow")
        window.makeKeyAndOrderFront(nil)
        if let start = Bundle.main.object(forInfoDictionaryKey: "StartURL") as? String, let u = URL(string: start) {
            remote = true
            web.load(URLRequest(url: u))
        } else if let dir = Bundle.main.resourceURL?.appendingPathComponent("web") {
            web.loadFileURL(dir.appendingPathComponent("index.html"), allowingReadAccessTo: dir)
        }
        let menu = NSMenu(); let appItem = NSMenuItem(); menu.addItem(appItem)
        let appMenu = NSMenu()
        appMenu.addItem(withTitle: "Quit " + ((Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String) ?? ""), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appItem.submenu = appMenu
        let editItem = NSMenuItem(); menu.addItem(editItem)
        let edit = NSMenu(title: "Edit")
        edit.addItem(withTitle: "Undo", action: Selector(("undo:")), keyEquivalent: "z")
        edit.addItem(withTitle: "Cut", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        edit.addItem(withTitle: "Copy", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        edit.addItem(withTitle: "Paste", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        edit.addItem(withTitle: "Select All", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        editItem.submenu = edit
        let winItem = NSMenuItem(); menu.addItem(winItem)
        let win = NSMenu(title: "Window")
        win.addItem(withTitle: "Minimize", action: #selector(NSWindow.miniaturize(_:)), keyEquivalent: "m")
        win.addItem(withTitle: "Close", action: #selector(NSWindow.performClose(_:)), keyEquivalent: "w")
        winItem.submenu = win
        let viewItem = NSMenuItem(); menu.addItem(viewItem)
        let view = NSMenu(title: "View")
        view.addItem(withTitle: "Reload", action: #selector(WKWebView.reload(_:)), keyEquivalent: "r")
        viewItem.submenu = view
        NSApp.mainMenu = menu
        NSApp.activate(ignoringOtherApps: true)
    }
    func userContentController(_ c: WKUserContentController, didReceive m: WKScriptMessage) {
        guard m.name == "ftCopy", let text = m.body as? String else { return }
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(text, forType: .string)
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ s: NSApplication) -> Bool { true }
    // Open external links in the default browser
    func webView(_ w: WKWebView, decidePolicyFor a: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if !remote, let u = a.request.url, u.scheme == "http" || u.scheme == "https" { NSWorkspace.shared.open(u); decisionHandler(.cancel) } else { decisionHandler(.allow) }
    }
    // Links that open a new tab load in the same window (keeps sign-in flows working)
    func webView(_ w: WKWebView, createWebViewWith c: WKWebViewConfiguration, for a: WKNavigationAction, windowFeatures f: WKWindowFeatures) -> WKWebView? {
        if let u = a.request.url { if remote { w.load(URLRequest(url: u)) } else { NSWorkspace.shared.open(u) } }
        return nil
    }
}
let app = NSApplication.shared
let d = AppDelegate()
app.delegate = d
app.setActivationPolicy(.regular)
app.run()
