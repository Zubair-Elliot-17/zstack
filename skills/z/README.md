# zstack

The user's own sprint: **Think → Plan → Build → Review → Test → Ship → Reflect**.
Each stage is a short skill (`/z-think` … `/z-reflect`); `/z` syncs merged PRs, shows status and resumes.
Quick lane: `/z-iterate` takes one fix or piece of feedback straight to a verified PR (most portfolio-site work).
STATE.md `Autonomy: full` (default) means the lead decides, answers gstack's questions itself and logs why; `guided` brings decisions to the user.

## How it fits together

| Stage | Team roles | gstack / other skills it calls | Writes |
|---|---|---|---|
| Think | researcher | `/office-hours` | research notes, design doc path |
| Plan | planner | `/autoplan` or `/plan-eng-review` (+ `/plan-design-review` for UI) | spec + task list in STATE.md |
| Build | implementer, or frontend-dev + backend-dev (Team mode) | `mattpocock-skills:tdd`, `/investigate` | code, role logs |
| Review | reviewer + security-auditor + tester (parallel) | `gstack-gate-diff`; `/review` (report only) or `/cso` on request | findings → implementer fixes |
| Test | tester | `/qa-only` (report only); `z-test/shots.py` (1440/390/320, Chromium + WebKit) | QA report, screenshots |
| Ship | lead | `/ship`, then `/land-and-deploy`, `/canary` on request | PR, deploy check |
| Reflect | researcher | `/retro`, `/learn` | team-improvements.md, archived STATE-<m>.md |
| Iterate (quick lane) | lead, + reviewer if non-trivial | `/investigate` for bugs; `z-test/shots.py` | one PR per change |

## Files
- `.claude/team/STATE.md` — single source of truth for where we are (lead only).
- `.claude/team/logs/<role>.md` — each role's progress log.
- `~/.gstack/projects/<slug>/` — gstack's design docs and test plans; STATE.md links to them.
- `~/.claude/research/` — researcher findings and team improvement proposals.

## Principles (borrowed from gstack's ETHOS, plus the team research)
1. Search before building: researcher checks what exists first.
2. Within the task, do it completely (tests, edge cases, error paths). Outside the task, change nothing; list it as separate scope. When gstack's "boil the ocean" and Karpathy's "surgical changes" seem to conflict, the task boundary in STATE.md decides.
3. The user owns direction, merges and first deploys. With `Autonomy: full` the lead makes every other call, logs it, and shows finished results; it runs commands itself instead of handing them over.
4. One writer per file; parallelise only independent work (Google "scaling agent systems").
5. Keep scaffolding light for strong models (arXiv 2609.20804).
6. Honest work (gstack ETHOS §4): a report is a claim until the lead re-runs it; gates are never weakened to get green without the user's OK; approved acceptance criteria are frozen (`plan-<m>.approved.md`).
7. Learn across sprints: gstack's per-project learnings (`gstack-learnings-search`) go into every plan, build and ship brief.

## Thesis mode
Projects with `Type: thesis` in STATE.md run the same sprint with academic steps (ARS skills, evidence checks, an examiner rubric, a submission gate). Each stage skill points to `THESIS.md`.

## Making it yours
Each stage is a plain SKILL.md under `~/.claude/skills/z-*`. To replace a gstack step, edit that stage to do the work itself and drop the gstack call.
