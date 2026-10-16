---
name: z-iterate
description: zstack quick lane. One small change or piece of user feedback on a project (a fix, a tweak, a layout or animation change, a small feature in existing files) taken straight to a PR — sync, branch, change, verify, self-review, PR. Use for "fix X", "I don't like Y", screenshots of a bug, post-ship tweaks, and small portfolio sites; use the full sprint (/z-think) for new products or changes to data, auth or several modules.
---

# z-iterate

Most of last week's work was this loop (Tablecloth PRs #1–#9, ROND #1–#7, Veld #2): one change, one PR. It keeps the honesty rules of the sprint without its ceremony.

**Use the full sprint instead** when the change adds a data model or state, touches auth, payments, secrets or uploads, spans more than one module, or would take more than about an hour. Say which lane you picked in one line.

1. **Sync** (`/z` step 1 does this on resume): `git fetch`, record PRs merged since STATE.md (`gh pr list --state merged --limit 10`), `git switch main && git pull`, delete merged local branches and worktrees. Read the user's own commits first so you never redo their work.
2. **Scope in one line** in STATE.md Tasks: what changes, what must not. If the request reads as both a small and a large job, take the reading the user's words support and state it in your reply.
3. **Branch** from main (`fix/<slug>`, `feat/<slug>`). If an earlier PR is still open, branch from main when independent, or stack on it and say so in the PR body; use a worktree (`../<repo>-<slug>`) when the main checkout holds unmerged work.
4. **Change it.** Apply the user's feedback memories that fit (e.g. nav-jump pattern). Bug: find the root cause first (gstack `/investigate` if it resists a quick fix). Add or update a test when the project has tests.
5. **Verify yourself** and keep the evidence (command + result, or screenshot paths):
   - project checks: typecheck, lint, tests, build;
   - UI changes: the `z-test` UI checks (desktop + 390px phone, Chromium + WebKit, every section, 0 console errors), compared with main so untouched sections did not change (the `.vineyard` clash in Tablecloth #8 broke a section nobody touched).
6. **Self-review.** Read your own diff. More than a few lines of logic, or anything you are unsure about: one `reviewer` agent on the diff (add `security-auditor` for input handling). Fix P1/P2 yourself, log P3s.
7. **PR.** Commit (no Claude attribution), push the branch, open the PR with what changed, why, and how it was verified. Merging stays with the user (auto mode blocks it): give the PR link in one line.
8. **Don't idle.** If more feedback is queued, start it now (step 3) instead of waiting for the merge. Log each PR in STATE.md Decisions and Tasks; keep `Stage: iterate`.
