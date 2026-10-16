---
name: z-test
description: zstack stage 5. Prove the change works for real — gstack /qa-only against the running app (browser, API, CLI) plus the tester's acceptance-criteria results. Use after z-review.
---

# z-test

**Thesis projects** (`Type: thesis` in STATE.md): follow the Test row and the rules in `~/.claude/skills/z/THESIS.md` instead of the steps below.

1. Start the app or point at a preview URL. Run gstack `/qa-only` on the changed behaviour (report only; `/qa` would commit its own fixes, breaking the one-writer rule).
   **UI checks** (any page change; most user bug reports last week were phone or Safari only — ROND's halved wheel, Tablecloth's iPhone toolbar and clock):
   - Widths 1440, 390 and 320; Chromium and WebKit. WebKit is installed: Playwright in `~/.claude/skills/repo-video/.venv` (`.venv/bin/python` with `p.webkit.launch()`).
   - A full-page screenshot of every section plus the console log on both engines; no horizontal overflow at phone widths; reduced motion still usable.
   - Compare with the same shots from main, so a change in one section that breaks another (Tablecloth #8 `.vineyard` clash) is caught before the user sees it.
   - Look at the screenshots yourself before calling it done; list their paths in the QA report.
2. Confirm each acceptance criterion has a passing test (from the `tester`), judged against the approved criteria: `diff .claude/team/plan-<milestone>.approved.md .claude/team/plan-<milestone>.md`. A criterion edited without a matching user-approved Decision counts as failed (gstack RH-10, "spec editing as progress"). Every failure goes back to `/z-build` for the implementer or owning teammate to fix.
3. Record the QA report path and pass/fail per criterion in STATE.md. Set `Stage: ship`, Next action `/z-ship`.
