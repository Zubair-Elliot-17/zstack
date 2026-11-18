# zstack

A sprint for Claude Code: **Think → Plan → Build → Review → Test → Ship → Reflect**.
Each stage is a short skill (`/z-think` … `/z-reflect`); `/z` syncs merged PRs, shows status and resumes.
Quick lane: `/z-iterate` takes one fix or piece of feedback straight to a verified PR (most day-to-day work).
STATE.md `Autonomy: full` (default) means the lead decides, answers any optional skill's questions itself and logs why; `guided` brings decisions to the user.

## How it fits together

| Stage | Team roles | Optional upgrades (built-in version in `FALLBACKS.md`) | Writes |
|---|---|---|---|
| Think | researcher | `/office-hours` | research notes, design doc path |
| Plan | planner | `/autoplan` or `/plan-eng-review` (+ `/plan-design-review` for UI) | spec + task list in STATE.md |
| Build | implementer, or frontend-dev + backend-dev (Team mode) | `mattpocock-skills:tdd`, `/investigate` | code, role logs |
| Review | reviewer + security-auditor + tester (parallel), then local-review + judge | gate check (or `gstack-gate-diff`); `/review` (report only) or `/cso` on request | findings → implementer fixes |
| Test | tester | `/qa-only` (report only); `z-test/shots.py` (1440/390/320, Chromium + WebKit) | QA report, screenshots |
| Ship | lead | `/ship`, then `/land-and-deploy`, `/canary` on request | PR, deploy check |
| Reflect | researcher | `/retro`, `/learn` | team-improvements.md, archived STATE-<m>.md |
| Iterate (quick lane) | lead, + reviewer if non-trivial, then local-review + judge | `/investigate` for bugs; `z-test/shots.py` | one PR per change |

## Modes
The lead picks the lightest that fits:
1. **Solo**: small, quick or single-file tasks. No agents.
2. **Pipeline**: most feature work. `planner` → open questions answered (by you, or by the lead with `Autonomy: full`) → `implementer` (sole writer) → `reviewer` + `security-auditor` + `tester` on the finished diff → fixes back to `implementer`.
3. **Team**: only when work splits into separate file areas that can be built in parallel (`frontend-dev` + `backend-dev` + `tester`). Needs Claude Code agent teams enabled. Give each teammate its goal, the files it owns and its deliverable, and have it send its plan to the lead for a "go" before it edits anything.

## Checkpoints
After every stage or big task, and at least every 30 minutes: update STATE.md and the role logs, make a local `wip: <what>` commit on a feature branch (never on main, no push without asking), and tell the user one line: what is saved, what is next.

## Files
- `.claude/team/STATE.md` — single source of truth for where we are (lead only).
- `.claude/team/logs/<role>.md` — each role's progress log.
- `docs/designs/` (or `~/.gstack/projects/<slug>/` with gstack): design docs and test plans; STATE.md links to them.
- `~/.claude/research/` — researcher findings and team improvement proposals.

## Principles (influenced by gstack's ETHOS and published agent research)
1. Search before building: researcher checks what exists first.
2. Within the task, do it completely (tests, edge cases, error paths). Outside the task, change nothing; list it as separate scope. Where "do it completely" and "change only what is needed" seem to conflict, the task boundary in STATE.md decides.
3. The user owns direction, merges and first deploys. With `Autonomy: full` the lead makes every other call, logs it, and shows finished results; it runs commands itself instead of handing them over.
4. One writer per file; parallelise only independent work (Google "scaling agent systems").
5. Keep scaffolding light for strong models (arXiv 2609.20804).
6. Honest work: a report is a claim until the lead re-runs it; gates are never weakened to get green without the user's OK; approved acceptance criteria are frozen (`plan-<m>.approved.md`).
7. Learn across sprints: the project's learnings (`.claude/team/learnings.md`) go into every plan, build and ship brief.

## Thesis mode
Projects with `Type: thesis` in STATE.md run the same sprint with academic steps (evidence checks, an examiner rubric, a submission gate). Each stage skill points to `THESIS.md`.

## Making it yours
Each stage is a plain SKILL.md under `${CLAUDE_PLUGIN_ROOT}/skills/z-*`. Built-in versions of every step live in `FALLBACKS.md` next to this file; optional tools (gstack, ponytail, mattpocock-skills) replace them when installed. Edit `FALLBACKS.md` to change a built-in step.
