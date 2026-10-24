---
name: z-ship
description: zstack stage 6. Ship the change — gstack /ship to open the PR, then /land-and-deploy and /canary when the user asks. Use after z-test.
---

# z-ship

**Thesis projects** (`Type: thesis` in STATE.md): follow the Ship row and the rules in `~/.claude/skills/z/THESIS.md` instead of the steps below.

1. `Autonomy: guided`: ask the user before pushing. `full`: pushing the feature branch and opening the PR is pre-approved (never main). Then run gstack `/ship` (sync main, tests, docs check, push, open PR). Follow the user's commit rules (no Claude attribution).
   - Before /ship, check `gstack-learnings-search --type pitfall` for known ship blockers in this repo. If the repo has no `.github/workflows/*.yml` or no JS/TS test runner (see STATE.md `Stack:`), skip /ship: its pregate can't map test lanes there and always fails (Swivel M1). Ship by hand instead: run the `Verify:` commands on the branch head, push, open the PR with each approved criterion as PASS / MANUAL-PASS / CARRIED @ sha in the body, and check README and docs against the diff yourself. For other blocked repos, try /ship once per sprint and bypass the same way only if it really blocks.
   - /ship's plan completion audit can't see `.claude/team/` and silently skips with "no plan". Publish the approved plan where it looks: `eval "$(~/.claude/skills/gstack/bin/gstack-slug)"; { echo "Branch: $BRANCH"; cat .claude/team/plan-<milestone>.approved.md; } > ~/.gstack/projects/$SLUG/zstack-plan-$BRANCH.md`, then pick it at /ship's plan question.
   - **Triage /ship findings once**, before any fix. Fix now: correctness, data loss, security or concurrency. Everything else goes to `TODOS.md` by default; the user can promote items.
   - Fix-now items go to the `implementer` (not the lead or /ship's auto-fix), each with a red-first regression test; the `reviewer` then re-checks only the fix diff.
   - At most 2 /ship cycles. After that, ask the user whether to ship with the rest logged as TODOs (`full`: ship with them logged and say so).
   - **Portfolio projects** (the user asked for these on every one): README case study in the first person as the user; a walkthrough video with `/repo-video` linked from the README; `main` protected like AI-CD (PRs required, the CI or Vercel check required and up to date, admins included, no force-push); live URL checked with 0 console errors. Do them in the first ship, not on request.
2. Merging and deploying need a separate OK. Auto mode blocks merging a PR no human approved, by design: don't attempt it or add an allow rule. Give the user `gh pr merge <n> --squash --delete-branch` (squash keeps `wip:` commits off main) or ask them to merge in the UI. Then `/land-and-deploy` and `/canary` when asked.
   - All the user's repos are squash-only (2026-10-15); set new repos the same way when you create them. If `gh repo view --json mergeCommitAllowed,rebaseMergeAllowed` shows either allowed, ask the user to make it squash-only: `gh repo edit --enable-merge-commit=false --enable-rebase-merge=false --delete-branch-on-merge`.
3. **After the merge, check every run on the merge commit**, not just the PR's checks: `gh run list --commit <merge-sha>` (deploy-triggered workflows such as smoke checks never show on the PR). Any failed run blocks reflect until it is explained or fixed. Summarise long CI logs with `local-llm` first.
   Record PR link, CI status and deploy result in STATE.md. Set `Stage: reflect`, Next action `/z-reflect`. Later feedback on the shipped work goes through `/z-iterate`.
