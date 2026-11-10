#!/usr/bin/env bash
# First-pass review of a diff by the local Ollama model. Usage: git diff HEAD | ollama-review.sh
set -euo pipefail

[ -t 0 ] && { echo "usage: git diff HEAD | ollama-review.sh" >&2; exit 2; }
diff="$(cat)"
[ -n "$diff" ] || { echo "ollama-review: empty diff, nothing to review"; exit 0; }

curl -sf -m 3 http://localhost:11434/api/tags >/dev/null ||
  { echo "ollama-review: Ollama is not running at localhost:11434 (start it with 'ollama serve'); review skipped" >&2; exit 3; }

printf '%s' "$diff" | LOCAL_LLM_MODEL=qwen3.5:9b local-llm 'You are reviewing a git diff. List only real problems, one line each, in the form "BUG|STYLE|TEST file:line - problem". BUG = likely defect, STYLE = style issue, TEST = missing test. No praise, no summary, no fixes. If there are none, print "no findings".' ||
  { echo "ollama-review: the model call failed; review skipped" >&2; exit 3; }
