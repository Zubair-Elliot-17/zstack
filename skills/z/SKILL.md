---
name: z
description: zstack entry point. Shows where the current project is in the zstack sprint (Think → Plan → Build → Review → Test → Ship → Reflect) or the quick lane (z-iterate), syncs merged PRs, resumes saved team work, and runs the next step. Use when the user says /z, "where were we", "continue", "carry on", "merged", or starts a new project with zstack.
---

# zstack

zstack is the user's own sprint, built on their agent team (`~/.claude/agents/`) and wrapping gstack where gstack is strongest. Read `~/.claude/skills/z/README.md` once if you need the full picture.

1. Look for `.claude/team/STATE.md` in the project root.
   - **Found:** read it plus the latest entry of each `.claude/team/logs/*.md`, and the project's learnings (`~/.claude/skills/gstack/bin/gstack-learnings-search --limit 10`; nothing printed means none yet). Skim long logs with `local-llm` first (treat its answer as a draft).
     **Sync before anything else:** `git fetch`; for each PR STATE.md lists as open, `gh pr view <n> --json state,mergeCommit`. Merged → pull main, record the merge SHA, run the z-ship post-merge check, delete the branch, mark the task done. Also note commits on main you didn't make (the user's own fixes). The user should never have to say "merged" for you to notice.
     Tell the user in 2–3 lines: goal, stage, what the sync found, next action. With `Autonomy: full`, continue straight on; otherwise ask whether to continue. A STATE.md with no `Autonomy` line predates this rule: treat it as `guided` until the user says otherwise.
   - **Not found:** take the goal from the user's message (ask only if there is none), create `.claude/team/` from `~/.claude/team-templates/STATE.md`, add `.claude/team/` to `.git/info/exclude`, and pick:
     - `Type`: `thesis` for a thesis or other academic writing (see `THESIS.md`), else `code`.
     - `Autonomy`: `full` (default; the user prefers decide-and-deliver) unless they ask to approve steps (`guided`).
     - `Lane`: `sprint` (new product, data/auth changes, several modules) → `Stage: think`, run `/z-think`; or `quick` (a small site, fix or tweak) → `Stage: iterate`, run `/z-iterate`.
2. To continue, invoke the skill for the stage in STATE.md (`z-think`, `z-plan`, `z-build`, `z-review`, `z-test`, `z-ship`, `z-reflect`, `z-iterate`). New feedback on a shipped project goes to `/z-iterate`, or a new sprint if it is big (see its first rule).
3. `Type: thesis` projects: every stage follows `~/.claude/skills/z/THESIS.md`. Its "claims need evidence" means quotes, counts and citations checked against the source files, not test runs.
4. Small one-off tasks don't need zstack; say so and just do them (Solo mode).

## Rules for every stage
- **Running roles.** When you launch a role in the background, add it to STATE.md `Running:` before doing anything else; remove it when its result arrives. While `Running:` names a tester, reviewer or auditor, don't edit tracked files in that checkout. After /clear or a resume, trust `Running:` over memory (ask the user to check `/tasks` if unsure).
- Long test runs go under `caffeinate -i`.
- **Checkpoint** (STATE.md + role logs + local WIP commit, see CLAUDE.md "# Projects") when a stage or big task ends, every 30 minutes, or when the user stops.
- **Autonomy.** `full`: decide and keep going. Take the recommended option on open questions, including the questions gstack skills ask (answer them yourself, don't relay them), log each in STATE.md Decisions with a one-line why, and show the user finished results. Stop only for: merging (the user merges; auto mode blocks it), deploying to production for the first time, spending money, publishing real people's or companies' material, or a change of direction the user hasn't asked for. `guided`: the user approves direction, the plan, and every push.
- **Run it yourself.** Never hand the user a command you can run. Only hand over what the guard blocks (merge: give the PR link) or what needs their login or credentials (suggest `! <command>`).
- **Don't idle on a PR.** After opening a PR, start the next task (from main if independent, stacked on the PR otherwise) and say so.
- **Briefs carry the user's preferences.** Subagents don't see auto memory: paste the `feedback` memories that touch the task (e.g. no Claude attribution, brief comments, nav-jump pattern) into every role brief.

**Claims need evidence** (from gstack's Honest Work): a role's "tests pass" or "done" is a claim until the lead re-runs the check and sees the output; before advancing a stage, cite the command, the SHA and the result. A suite that ran zero tests is not a pass, and "done, unverified" is not "done". Deleting or skipping a test, relaxing a timeout or threshold, adding a suppression, or `--no-verify` needs the user's OK by name, logged in Decisions. Autonomy never covers these.
