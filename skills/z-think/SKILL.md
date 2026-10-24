---
name: z-think
description: zstack stage 1. Understand the problem before planning — research what exists, then sharpen the idea with gstack /office-hours. Use at the start of a new project or feature.
---

# z-think

**Thesis projects** (`Type: thesis` in STATE.md): follow the Think row and the rules in `~/.claude/skills/z/THESIS.md` instead of the steps below.

1. **Search before building.** Ask the `researcher` to find how others solve this (existing libraries, apps, papers, videos) and what we should reuse vs build. For a feature seen in another app, it may use `reverse-engineer-anything`. Wait for its findings file.
2. **Pin the scope.** Write one line in STATE.md Goal naming what is in and out, with counts where they exist ("all 32 pages + 160 posts", not "the site"). When the request could mean a small or a large job, take the reading the user's words support; the FS-Systems redesign started as one page when the user meant the whole site.
3. **Sharpen the idea.** `Autonomy: guided`: run gstack `/office-hours` with the user, sharing the researcher's key findings. `Autonomy: full`: skip the interview; write a short design note yourself (problem, audience, the one bold idea, what we reuse) under `docs/designs/` or `~/.gstack/projects/`.
4. Record in STATE.md: goal, `Stack:` and `Verify:` (build + test commands; see `~/.claude/team-templates/stacks.md`), design doc path, research file path, key decisions. Set `Stage: plan` and Next action `/z-plan`.
5. `guided`: tell the user what was decided and ask before moving to Plan. `full`: say it in two lines and go on.
