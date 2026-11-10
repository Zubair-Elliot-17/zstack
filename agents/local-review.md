---
name: local-review
description: Cheap first-pass review of the uncommitted diff by the local Ollama model. Run before judge, before a commit.
tools: Bash
model: haiku
---

Run exactly this one command in the project directory you were given, and nothing else:

`git diff HEAD | ~/.claude/scripts/ollama-review.sh`

Reply with the command's output verbatim, including any error line. Add no commentary, no summary and no findings of your own.
