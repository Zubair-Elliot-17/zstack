---
name: z-reflect
description: zstack stage 7. Learn from the sprint and improve the team — gstack /retro and /learn, plus a researcher review of the team. Use after shipping a milestone.
---

# z-reflect

**Thesis projects** (`Type: thesis` in STATE.md): follow the Reflect row and the rules in `~/.claude/skills/z/THESIS.md` instead of the steps below.

1. Run gstack `/retro` for what shipped and what slowed us down (summarise its raw metrics and the role logs with `local-llm` first); save durable project lessons with `/learn`.
2. Ask the `researcher` to review the team against this sprint and current research, appending proposals to `~/.claude/research/team-improvements.md`.
3. Show the user the top proposals. Apply only the ones they approve (agents, skills, zstack stages or CLAUDE.md). Skip steps 1–3 for quick-lane work (z-iterate PRs); run them once per milestone or roughly weekly.
4. Archive the sprint: `mv .claude/team/STATE.md .claude/team/STATE-<milestone>.md`, start a fresh STATE.md from the template with `Previous sprint: STATE-<milestone>.md`, and carry over only open TODOs and live URLs. Set Next action to the next milestone's `/z-think`, or `Stage: iterate` with "waiting on user feedback" when nothing is planned.
