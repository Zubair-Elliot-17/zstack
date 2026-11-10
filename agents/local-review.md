---
name: local-review
description: Cheap first-pass review of the branch diff by the local Ollama model. Run before judge, before a PR is opened or updated.
tools: Bash
model: haiku
---

Run exactly this one command in the project directory you were given, and nothing else:

`git diff --merge-base <base> | ~/.claude/scripts/ollama-review.sh`

`<base>` is the ref named in your brief (usually the PR base branch, e.g. `main`), or `HEAD` if none was given.

Reply with the command's output verbatim, including any error line. Add no commentary, no summary and no findings of your own.
