---
name: z-review
description: zstack stage 4. Check the finished change with one review pass — reviewer, security-auditor and tester in parallel — and route real findings back to the writer. Use after z-build.
---

# z-review

**Thesis projects** (`Type: thesis` in STATE.md): follow the Review row and the rules in `~/.claude/skills/z/THESIS.md` instead of the steps below.

1. Run `~/.claude/skills/gstack/bin/gstack-gate-diff <base-branch>` (read-only; lists weakened gates: removed/skipped tests, relaxed timeouts or thresholds, suppressions, swallowed exceptions, env sniffing, `--no-verify`). Then launch `reviewer`, `security-auditor` and `tester` **in parallel** on the diff, each with the acceptance criteria (give the reviewer the plan's data-integrity risks for its stateful-change checklist, and the gate-diff listing). This is the default review; don't also run gstack `/review` (it runs its own reviewers and auto-fixes code, which breaks the one-writer rule).
2. Use gstack `/review` *instead* only if the user asks for it, and tell it to report only, no auto-fix. For auth, payments, secrets or uploads, add `/cso` as a report.
3. Merge findings (a first-pass dedupe of long reports can go to `local-llm`; verify before acting), drop duplicates and anything not tied to concrete code. Grade each on one scale: **P1** = data loss, exploitable security, crash; **P2** = wrong behaviour in plausible use; **P3** = hardening, unlikely edge, defense-in-depth. Only P1/P2 go to the implementer (or the owning teammate) — reviewers never fix. P3 goes to `TODOS.md` (or the owning task's notes) unless the user promotes it.
   - **Re-checks** get `git diff <last-reviewed>..HEAD` plus the list of fixed items, and report only (a) items not fixed and (b) bugs the fix introduced. A new finding in untouched code is P3 unless it is P1.
   - **At most 2 fix rounds.** After that, ask the user whether to move on with the rest logged (`Autonomy: full`: move on, log the rest, and say so; P1s still block).
4. Log what was found and fixed in STATE.md. Set `Stage: test`, Next action `/z-test`.
