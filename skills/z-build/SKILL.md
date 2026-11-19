---
name: z-build
description: zstack stage 3. Build the planned tasks with the team — one implementer in Pipeline mode, or frontend-dev + backend-dev teammates with separate files in Team mode. Use after z-plan.
---

# z-build

**Thesis projects** (`Type: thesis` in STATE.md): follow the Build row and the rules in `${CLAUDE_PLUGIN_ROOT}/skills/z/THESIS.md` instead of the steps below.

- Every brief includes the smallest-change rule (see `/z` rules), the project's pitfalls (`pitfall:` lines in `.claude/team/learnings.md`, or `gstack-learnings-search --type pitfall --limit 10`) that touch the task's files, the user's saved preferences that touch the task (memory or CLAUDE.md; subagents don't see them), and the matching section of `${CLAUDE_PLUGIN_ROOT}/team-templates/stacks.md`.
- **Mode by size.** A single-file or single-area build (most small sites) is Solo: the lead builds and an independent `reviewer` checks in z-review. Use the implementer once there are tests to write against a plan.
- **Pipeline:** brief the `implementer` with the task list, acceptance criteria, relevant skills and file paths. It works sequentially, test-first (write the failing test, make it pass, then tidy; `mattpocock-skills:tdd` optional). A fix in a native app target gets a red-first test in `<App>AppTests` (see stacks.md); "no test (app target)" is not an accepted reason, "can't force the OS state" is, if logged.
- **Team:** spawn `frontend-dev`, `backend-dev` (and `tester` if useful) as teammates. Each spawn prompt states the goal, files owned, who to message, and the deliverable. Warn the user it costs about one session per teammate.
- A bug that resists a quick fix → "Investigate" in `${CLAUDE_PLUGIN_ROOT}/skills/z/FALLBACKS.md` (no fixes without a root cause).
- If the plan ships in several PRs, open each one when its tasks pass, then keep building the next on a stacked branch instead of waiting for the merge. Stack with `gh stack` (GitHub native stacked PRs, gh ≥ 2.90) when available: GitHub rebases the rest when the bottom PR merges. Otherwise record `Stacked on: <branch> @ <tip sha>` in STATE.md `Branch / PR:`, and after the base is squash-merged run `git rebase --onto origin/main <recorded tip> <branch>`, re-run `Verify:`, then `git push --force-with-lease`.
- **Trail** (sprint lane). At every handoff (task done, role reported, role skipped) the lead flips that STATE.md task row and appends one line to `.claude/team/logs/lead.md`; a skipped role is logged as skipped with the reason. Put the task ID in WIP commit subjects (`wip: T3 <what>`). A STATE.md row still `todo` after its PR merged is a stale trail.
- **Resuming a cut-off implementer** (usage limit, user stop): brief it with `git log --oneline <base>..HEAD` and the last line of its log, and have the lead log the stop point if the role could not.
- After each finished task, update STATE.md task status. When all tasks are done, the lead re-runs typecheck, lint and tests itself (don't trust the report; see "Claims need evidence" in `/z`); only on a real pass set `Stage: review`, Next action `/z-review`.
