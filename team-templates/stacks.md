# Stack notes

Paste the matching section into plan, build and test briefs. Each note carries the date it was last verified; re-check stale ones.

## macOS SwiftPM, Command Line Tools only (no Xcode)
Verified 2026-10-24 on macOS 26.6.2, Swift 6.3.2 (Swivel M1).

- **Tests:** XCTest is absent. `import Testing` fails unless SwiftPM gets the CLT paths. Copy `~/claude-work/projects/swivel/scripts/test.sh`. It runs `swift test` with `-Xswiftc -F$F -Xlinker -F$F -Xlinker -rpath -Xlinker $F -Xlinker -rpath -Xlinker $L`, where F=`/Library/Developer/CommandLineTools/Library/Developer/Frameworks` and L=`/Library/Developer/CommandLineTools/Library/Developer/usr/lib`.
- **App bundle:** a bare `swift run` binary can miss the macOS 26 menu-bar allow list, which keys on bundle ID. Build a `.app` with a script (Info.plist with `LSUIElement`, `codesign --force -s -`). Avoid SwiftPM resources (`Bundle.module`) in hand-built bundles. Copy `swivel/scripts/bundle.sh`.
- **Logs:** `os.Logger` `.info` lines are hidden by `log stream` unless you pass `--level info`. Afterwards, read them with `log show --info --last 30m --predicate 'subsystem == "<id>"'`.
- **Testability:** pure logic goes in a library target (Swivel's `SwivelCore`) for unit and mutation tests. App-target (AppKit) code is testable too: add `.testTarget(name: "<App>AppTests", dependencies: ["<App>"])` and `@testable import <App>` (SwiftPM 5.5+). Top-level `main.swift` code doesn't run in tests, so move logic you want tested into a type in another file.
- **Uncatchable exceptions:** AVFoundation and AppKit raise ObjC `NSInvalidArgumentException` on out-of-range settings (e.g. a WAV sample rate outside 8–192 kHz), which Swift can't catch; clamp to the documented range before the call.
- **UI checks:** test views offscreen in `<App>AppTests` (`bitmapImageRepForCachingDisplay` + `cacheDisplay`, then `colorAt`, `hitTest` or AX children). XCUITest and Appium need Xcode; drive real gestures with the macui kit instead.
- **Scripted QA:** give menu-bar apps a QA entry point: the bundle accepts `--qa-drop <slice> <path>...` only when `<APP>_QA=1` is set, calls the same drop handler the UI calls (never lower), logs the summary line and quits. Drive it with `<APP>_QA=1 open -W -n build/<App>.app --args --qa-drop ...`; a `scripts/qa.sh` builds fixtures (sips, cupsfilter, `hdiutil create -format UDRO` for read-only volumes) and checks outputs and the log line. Only gesture, permission and VoiceOver rows stay manual.
- **Hostile numbers:** `Int(Double)`/`Int32(...)` trap (crash) on NaN, ±inf or out-of-range. Sizes, boxes, DPI and counts read from files stay Double until checked finite and in range, then `Int(exactly:)` or clamp. Audit grep: `grep -rnE '\bU?Int(8|16|32|64)?\(' Sources | grep -v 'exactly\|clamping\|truncating\|bitPattern'`.
- **Manual QA:** posting synthetic input (CGEvent) or scripting UI with osascript needs Accessibility, which the user must grant. Once the user has granted it, drags and gestures are `ui` rows driven by `~/.claude/team-templates/macui/` (see z-test); only what the kit can't drive (spoken VoiceOver, TCC prompts, other OS versions) stays on the Manual QA card.
- **Ship:** gstack `/ship`'s pre-gate can't map test lanes without CI and a JS import graph, so ship by hand (z-ship). Verify commands: `scripts/test.sh` and `swift build` (0 warnings).
