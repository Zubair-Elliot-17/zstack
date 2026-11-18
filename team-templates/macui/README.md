# macui: synthetic UI QA for native Mac apps (CLT only)

The tools behind z-test's `ui` rows. Build with `build.sh` (default `~/.cache/macui`, so it survives /clear; rebuilds only changed tools).
The terminal needs Accessibility (to post events and read the AX tree); the user grants it, never the agent.

- `ev <cmd> …`: posts CGEvents. Commands: `move x y`, `down x y`, `up x y`, `drag x y steps`, `click x y`, `dclick x y`,
  `shift`, `ctrl`, `esc` (taps), `shiftdown`/`shiftup`, `sleep ms`; several can be chained in one call. Global, top-left coordinates.
- `axfind <bundle-id|pid> [x]`: dumps role, label and frame of every AX element; find targets here, never hard-code coordinates.
- `axpress <bundle-id> <menu item>`: opens a menu-bar extra and presses the item. AX press: doesn't activate the app.
- `menu.sh <bundle-id> [item]`: real-clicks the menu-bar extra (activates the app), then the named item; exit 1 if not found.
- `axbtn <bundle-id> <title>`: presses a window button.
- `pos.sh <file>`: centre of a file's icon in the front Finder window.
- `preflight.sh <fixtures>`: Stage Manager off, no full-screen apps, fixtures outside iCloud folders.
- `repeat.sh <n> <gesture> <check>`: run a gesture n times and count the bad outcome.

Rules: a negative row ("X does not happen") counts only if the same gesture with one setting flipped shows X in the same run; re-locate targets right before each gesture. Logs: `/usr/bin/log stream --level info` (zsh's `log` is a builtin; `log show` needs `--info`). Assert on effects, not on the press (the window is key: Esc or Cmd-W closes it, with a negative control after clicking Finder; AXWindow count; file or log line; System Events `frontmost` is wrong for LSUIElement apps); a press that returns OK proves nothing about activation. Activate the target app in the same step as the gesture (focus moves between calls); assert on files and logs, keep one
screenshot per row as evidence; an app's success path may log nothing, so pair "no error line" with a visible or file result.

Input must reach the code under test: polled key state needs a held key (`ev esc`, or `shiftdown … sleep 80 … shiftup`), never osascript `key code` (0 ms). A positive control runs the same code path as the row (same input tool and timing, one setting flipped); a pass through a different path is not a control. Before recording a FAIL, re-run with `ev` and log which path fired.

Recipes:
- Opening apps like a person: `ev dclick x y` on the Finder icon (real click state 1 then 2).
- App Translocation is lifted only by a real Finder drag (`ev drag`) into Applications, not AppleScript `move` or `mv`; `xattr -p com.apple.quarantine` then shows flag `01c3` (observed, not documented by Apple).
- VoiceOver: Cmd-F5 first shows "Use VoiceOver?" and then the VoiceOver Quickstart, which swallows VO keys: click "Use VoiceOver", quit the Quickstart, then send keys. Scripting VoiceOver (`content of last phrase`) needs `defaults write com.apple.VoiceOver4/default SCREnableAppleScript -bool true`, which the user sets, not the agent; otherwise screenshot the caption panel.
