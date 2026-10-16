# zstack

**A sprint for Claude Code: Think → Plan → Build → Review → Test → Ship → Reflect.**

zstack turns Claude Code into a small software team with a memory. You type `/z` in a project, and it works out where things stand, syncs any merged PRs, and runs the next step: planning, building, reviewing, testing or shipping. Progress lives in a plain `STATE.md` file, so work survives a closed terminal, a crash or a new session.

It's built from plain Markdown skills and agent definitions. You can read each one in a minute and change it in two.

```
 /z ──► think ──► plan ──► build ──► review ──► test ──► ship ──► reflect
  │                                                        ▲
  └──────────────► iterate (quick lane: fix → verify → PR) ┘
```

---

## Why

Coding agents are fast but forgetful. Long tasks drift, "tests pass" gets claimed without running them, and when a session ends, its context is gone. zstack fixes this with a few simple rules:

- **One source of truth.** `.claude/team/STATE.md` records the stage, the task list, the decisions and the single *Next action*. A hook loads it at the start of every session.
- **Claims need evidence.** A role saying "done" is only a claim until the lead re-runs the check and sees the output. Deleting a test or loosening a threshold needs your OK by name.
- **One writer per file.** Agents run in parallel only on work that's actually independent.
- **You own direction and merges.** With `Autonomy: full`, the lead makes every other call, logs why, and shows you finished results instead of asking questions.
- **Checkpoints.** STATE.md, role logs and a local WIP commit after every stage and every 30 minutes.

## The sprint

| Stage | Command | Who works | What comes out |
|---|---|---|---|
| Think | `/z-think` | researcher | research notes, design doc |
| Plan | `/z-plan` | planner | spec + ordered task list, frozen acceptance criteria |
| Build | `/z-build` | implementer (or frontend-dev + backend-dev in parallel) | code + tests, role logs |
| Review | `/z-review` | reviewer + security-auditor + tester, in parallel | findings routed back to the writer |
| Test | `/z-test` | tester | QA report, screenshots at 1440 / 390 / 320 px in Chromium + WebKit |
| Ship | `/z-ship` | lead | PR, post-merge check, deploy check on request |
| Reflect | `/z-reflect` | researcher | retro, learnings, proposed team improvements |
| **Iterate** | `/z-iterate` | lead (+ reviewer) | one fix or tweak → one verified PR |

Most day-to-day work, like fixes, design tweaks and small sites, goes through the **quick lane**, `/z-iterate`. It runs sync → branch → change → verify → self-review → PR with the same honesty rules and less ceremony. New products and changes that touch data, auth or several modules get the full sprint.

There's also a **thesis mode** (`Type: thesis` in STATE.md) that runs the same stages with academic checks: evidence verified against sources, an examiner rubric and a submission gate. See [`skills/z/THESIS.md`](skills/z/THESIS.md).

## The team

Eight roles in [`agents/`](agents/):

| Role | Job |
|---|---|
| `planner` | Turns a request into a spec and a task list. Read-only. |
| `implementer` | The only writer in Pipeline mode. Works through tasks test-first. |
| `frontend-dev` / `backend-dev` | Parallel writers in Team mode, each owning separate files. |
| `reviewer` | Correctness, design and code quality on the finished diff. |
| `security-auditor` | Auth, input handling, secrets, injection. Findings tagged P1–P3. |
| `tester` | Checks the change against the acceptance criteria and writes missing tests. |
| `researcher` | Tech choices, "is there a better way", and periodic reviews of the team itself. |

The lead (your main Claude Code session) picks the lightest mode that fits: **Solo** for small tasks, **Pipeline** (planner → implementer → reviewers) for most features, or **Team** (parallel teammates) when the work splits cleanly by file.

## Install

Requirements: [Claude Code](https://docs.claude.com/en/docs/claude-code), `git`, `gh` (logged in) and `jq`. The hooks use macOS `stat`; on Linux, change `stat -f %m` to `stat -c %Y` in `hooks/zstack-guard.sh`.

```bash
git clone https://github.com/Zubair-Elliot-17/zstack.git
cd zstack
./install.sh
```

The installer copies everything into `~/.claude`. If a file with the same name already exists, it keeps a `.bak` copy. It then prints the hook block to add to `~/.claude/settings.json`:

- **`team-resume.sh`** (SessionStart) loads the saved STATE.md and the latest role-log entries, so a new session picks up where the last one stopped.
- **`zstack-guard.sh`** (UserPromptSubmit + Stop) nudges you into `/z` for projects under `~/claude-work/projects/` and asks for a checkpoint when STATE.md is more than 30 minutes old and files have changed.

### Works best with (optional)

zstack wraps these where they're strongest. Without them, the stages still run, and the lead does that step itself:

- [gstack](https://github.com/garrytan/gstack): `/office-hours`, `/autoplan`, `/qa-only`, `/ship`, `/retro`, `/learn`
- `andrej-karpathy-skills`, `mattpocock-skills` and the ECC skills that the agents preload (`coding-standards`, `ecc-security-review`, `react-patterns`, `api-design`)
- [Playwright](https://playwright.dev/python/) for `skills/z-test/shots.py`
- a `local-llm` command (e.g. a small Ollama model) to summarise long logs cheaply. Skip it and Claude reads the logs itself.

## Quick start

```text
cd ~/claude-work/projects/my-app
claude
> /z build a habit tracker with streaks
```

`/z` creates `.claude/team/STATE.md`, which is excluded from git so it stays local. It picks the lane and starts. Next time, just type `/z`, or say "carry on".

## Make it yours

Every stage is one short `SKILL.md` under `skills/z-*`, and every role is one Markdown file under `agents/`. To swap a gstack step for your own, edit that stage so it does the work itself. To change how strict a reviewer is, edit `agents/reviewer.md`. **Forking is encouraged.** The design notes are in [`skills/z/README.md`](skills/z/README.md).

## Contributing

Pull requests are welcome. `main` is protected, and every PR needs the maintainer's approving review before it can merge. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
