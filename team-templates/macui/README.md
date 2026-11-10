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

Rules: a negative row ("X does not happen") counts only if the same gesture with one setting flipped shows X in the same run; re-locate targets right before each gesture. Logs: `/usr/bin/log stream --level info` (zsh's `log` is a builtin; `log show` needs `--info`). Assert on effects, not on the press (frontmost app, AXWindow count, file or log line); a press that returns OK proves nothing about activation. Activate the target app in the same step as the gesture (focus moves between calls); assert on files and logs, keep one
screenshot per row as evidence; an app's success path may log nothing, so pair "no error line" with a visible or file result.
