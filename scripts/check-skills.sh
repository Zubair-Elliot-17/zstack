#!/usr/bin/env bash
# CI check: stages are self-contained and nothing depends on a missing skill.
set -u
cd "$(dirname "$0")/.." || exit 1
fail=0
bad() { echo "FAIL: $*"; fail=1; }

for f in skills/*/SKILL.md; do
  d=$(basename "$(dirname "$f")")
  [ "$(sed -n 's/^name: //p' "$f" | head -1)" = "$d" ] || bad "$f: name must be $d"
  grep -q '^description: ' "$f" || bad "$f: no description"
done

# every /z-<stage> reference resolves to a skill dir
for s in $(grep -rhoE '/z-[a-z]+' skills agents README.md | sort -u); do
  [ -d "skills/${s#/}" ] || bad "reference to $s has no skills/${s#/}/"
done

# agents must not preload skills (they may be absent)
grep -lE '^skills:' agents/*.md | while read -r f; do echo "FAIL: $f preloads skills"; done | grep . && fail=1

# every stage that mentions an optional tool must point at the built-in steps
for f in skills/z-*/SKILL.md; do
  if grep -qE 'gstack|/qa-only|/office-hours|/ship\b' "$f"; then
    grep -q 'FALLBACKS.md' "$f" || bad "$f mentions an optional tool but not FALLBACKS.md"
  fi
done
[ -f skills/z/FALLBACKS.md ] || bad "skills/z/FALLBACKS.md missing"
bash scripts/doctor.sh | grep -q 'gstack' || bad "doctor.sh printed no tool list"
# dropped references must not creep back (CHANGELOG may mention them)
grep -rniE 'karpathy|academic-research|\bars-' skills agents README.md team-templates scripts/doctor.sh && bad "dropped reference found"
[ "$fail" = 0 ] && echo "ok"
exit "$fail"
