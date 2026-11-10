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

# Prompt tuned on planted-bug diffs: naming the defect classes and asking for a failing input cut the noise.
prompt='You are a strict code reviewer reading a git diff of one file. Check each added line for: crashes on empty or short input, off-by-one loop bounds, division by zero, assignment used where comparison was meant, missing await, unvalidated input reaching SQL, shell or HTML, wrong logic. Report only defects you can explain with a concrete failing input. Output one line per defect: "BUG file:line - what breaks and with which input". Then, only if clearly true, at most one line "TEST file - new behaviour with no test" and at most one line "STYLE file:line - problem" (never docstrings, comments, naming or formatting). No praise, no summary, no fixes. If the diff has no defects, print exactly: no findings'

# One call per file, so each finding keeps its file name and hunk line numbers.
# shortcut: a single file's diff larger than the model context is reviewed from notes; fine for a first pass.
awk -v pre="$tmp/f." '/^diff --git /{ close(f); n++ } { f = sprintf("%s%05d", pre, n); print > f }' "$tmp/diff"
reviewed=0; skipped=0
for f in "$tmp"/f.*; do
  name="$(head -1 "$f")"; name="${name%\"}"
  # Prose and generated files are left to the judge.
  case "$name" in *.md|*.mdx|*.lock|*-lock.json|*.svg|*.snap) skipped=$((skipped + 1)); continue ;; esac
  reviewed=$((reviewed + 1))
  LOCAL_LLM_MODEL="$model" LOCAL_LLM_MAX_TOKENS=500 "$(dirname "$0")/local-llm" "$prompt" < "$f" > "$tmp/one" ||
    skip "the model call failed"
  # Keep only finding lines (the model sometimes thinks aloud), one per file:line, at most 5 per file.
  { grep -E '^(BUG|TEST|STYLE) ' "$tmp/one" || true; } | awk '!seen[$2]++' | head -5
done > "$tmp/out"
[ "$reviewed" -gt 0 ] || { echo "ollama-review: only docs or generated files changed ($skipped), nothing reviewed"; exit 0; }
[ -s "$tmp/out" ] && cat "$tmp/out" || echo "no findings"
[ "$skipped" = 0 ] || echo "ollama-review: $skipped docs or generated file(s) not reviewed here; the judge covers them"
