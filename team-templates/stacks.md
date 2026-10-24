# Stack notes

Paste the matching section into plan, build and test briefs. Each note carries the date it was last verified; re-check stale ones.

## macOS SwiftPM, Command Line Tools only (no Xcode)
Verified 2026-10-24 on macOS 26.6.2, Swift 6.3.2 (Swivel M1).

- **Tests:** XCTest is absent. `import Testing` fails unless SwiftPM gets the CLT paths. Copy `~/claude-work/projects/swivel/scripts/test.sh`. It runs `swift test` with `-Xswiftc -F$F -Xlinker -F$F -Xlinker -rpath -Xlinker $F -Xlinker -rpath -Xlinker $L`, where F=`/Library/Developer/CommandLineTools/Library/Developer/Frameworks` and L=`/Library/Developer/CommandLineTools/Library/Developer/usr/lib`.
- **App bundle:** a bare `swift run` binary can miss the macOS 26 menu-bar allow list, which keys on bundle ID. Build a `.app` with a script (Info.plist with `LSUIElement`, `codesign --force -s -`). Avoid SwiftPM resources (`Bundle.module`) in hand-built bundles. Copy `swivel/scripts/bundle.sh`.
- **Logs:** `os.Logger` `.info` lines are hidden by `log stream` unless you pass `--level info`. Afterwards, read them with `log show --info --last 30m --predicate 'subsystem == "<id>"'`.
- **Testability:** move gesture and geometry logic into a pure library target (Swivel's `SwivelCore`), so it can be unit- and mutation-tested. AppKit glue stays thin.
- **UI checks:** render views offscreen to PNG and look at the result. There is no UI-test harness without Xcode.
- **Manual QA:** posting synthetic input (CGEvent) or scripting UI with osascript needs Accessibility, which the user must grant. Drags and gestures are therefore manual QA rows (see z-test's Manual QA card).
- **Ship:** gstack `/ship`'s pre-gate can't map test lanes without CI and a JS import graph, so ship by hand (z-ship). Verify commands: `scripts/test.sh` and `swift build` (0 warnings).
