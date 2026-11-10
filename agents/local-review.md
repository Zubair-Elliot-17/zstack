---
name: local-review
description: Cheap first-pass review of the branch diff by the local Ollama model. Run before judge, before a PR is opened or updated.
tools: Bash
model: haiku
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: '"$HOME"/.claude/hooks/git-readonly.sh review'
          onFailure: block
---

Run exactly this one command, prefixed with `cd <project directory> && ` if you were given one, and nothing else (a hook blocks any other command):

`git diff --merge-base <base> | ~/.claude/scripts/ollama-review.sh`

`<base>` is the ref named in your brief (usually the PR base branch, e.g. `main`), or `HEAD` if none was given.

Run it with the Bash timeout set to 600000.

Reply with the command's output verbatim, including any error line. Add no commentary, no summary and no findings of your own.
