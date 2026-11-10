#!/usr/bin/env bash
# First-pass review of a diff by the local Ollama model. Usage: git diff --merge-base main | ollama-review.sh
set -euo pipefail

model="${OLLAMA_REVIEW_MODEL:-qwen3.5:9b}"
skip() { echo "ollama-review: $1; review skipped" >&2; exit 3; }

[ -t 0 ] && { echo "usage: git diff --merge-base main | ollama-review.sh" >&2; exit 2; }
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cat > "$tmp/diff"
[ -s "$tmp/diff" ] || { echo "ollama-review: empty diff, nothing reviewed"; exit 0; }

tags="$(curl -sf -m 3 http://localhost:11434/api/tags)" ||
  skip "Ollama is not running at localhost:11434 (start it with 'ollama serve')"
printf '%s' "$tags" | grep -qF "\"$model\"" || skip "model $model is not installed (run: ollama pull $model)"

# One call per file, so each finding keeps its file name and hunk line numbers.
# shortcut: a single file's diff larger than the model context is reviewed from notes; fine for a first pass.
awk -v pre="$tmp/f." '/^diff --git /{ close(f); n++ } { f = sprintf("%s%05d", pre, n); print > f }' "$tmp/diff"
for f in "$tmp"/f.*; do
  LOCAL_LLM_MODEL="$model" "$(dirname "$0")/local-llm" 'You are reviewing a git diff of one file. List only real problems, one line each, in the form "BUG|STYLE|TEST file:line - problem". BUG = likely defect, STYLE = style issue, TEST = missing test. No praise, no summary, no fixes. If there are none, print "no findings".' < "$f" ||
    skip "the model call failed"
done > "$tmp/out"
grep -vixE '[[:space:]]*no findings\.?[[:space:]]*|[[:space:]]*' "$tmp/out" || echo "no findings"
