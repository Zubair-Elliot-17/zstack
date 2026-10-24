---
name: z-build
description: zstack stage 3. Build the planned tasks with the team — one implementer in Pipeline mode, or frontend-dev + backend-dev teammates with separate files in Team mode. Use after z-plan.
---

# z-build

**Thesis projects** (`Type: thesis` in STATE.md): follow the Build row and the rules in `~/.claude/skills/z/THESIS.md` instead of the steps below.

- Every brief includes the project's pitfalls (`~/.claude/skills/gstack/bin/gstack-learnings-search --type pitfall --limit 10`) that touch the task's files, the user's feedback memories that touch the task (subagents don't see auto memory), and the matching section of `~/.claude/team-templates/stacks.md`.
- **Mode by size.** A single-file or single-area build (most portfolio sites) is Solo: the lead builds and an independent `reviewer` checks in z-review. Use the implementer once there are tests to write against a plan.
- **Pipeline:** brief the `implementer` with the task list, acceptance criteria, relevant skills and file paths. It works sequentially, test-first (`mattpocock-skills:tdd`).
- **Team:** spawn `frontend-dev`, `backend-dev` (and `tester` if useful) as teammates. Each spawn prompt states the goal, files owned, who to message, and the deliverable. Warn the user it costs about one session per teammate.
- A bug that resists a quick fix → gstack `/investigate` (no fixes without a root cause).
- If the plan ships in several PRs, open each one when its tasks pass, then keep building the next on a stacked branch instead of waiting for the merge.
- After each finished task, update STATE.md task status. When all tasks are done, the lead re-runs typecheck, lint and tests itself (don't trust the report; see "Claims need evidence" in `/z`); only on a real pass set `Stage: review`, Next action `/z-review`.
