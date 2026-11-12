# Fast Track Mac apps

Small native macOS apps (Swift + WebKit) wrapping Partner Success tools.

- `my-ai-agents/` – flip cards for Partner Success AI agents. Cards are bundled in `web/index.html` (source of truth: the My AI Agents artifact on artifacts.fasttrack.dev).
- `pm-task-board/` – opens the live PM Task Board artifact (URL in `Info.plist` under `StartURL`). Change that URL to point at your own copy.

## Build

Needs Apple Command Line Tools (`xcode-select --install`).

    cd my-ai-agents && ./build.sh

The `.app` is created in the same folder; copy it to `~/Applications`. Apps are ad-hoc signed, so on another Mac right-click the app and choose Open the first time.
