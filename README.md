# Fast Track Mac apps

Small native macOS apps (Swift + WebKit) wrapping Partner Success tools.

- `my-ai-streams/` – My AI Streams: flip cards for Partner Success AI streams. Cards are bundled in `web/index.html` (source of truth: the My AI Streams artifact on artifacts.fasttrack.dev).
- `pm-task-board/` – opens the live PM Task Board artifact (URL in `Info.plist` under `StartURL`). Change that URL to point at your own copy.

## Build

Needs Apple Command Line Tools (`xcode-select --install`).

    cd my-ai-streams && ./build.sh

The `.app` is created in the same folder; copy it to `~/Applications`. Apps are ad-hoc signed, so on another Mac right-click the app and choose Open the first time.
