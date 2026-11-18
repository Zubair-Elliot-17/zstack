# Built-in steps

zstack works with nothing else installed. Some stages can hand a step to an optional tool (marked "optional upgrade"); when that tool is missing, do the step as written here. If both exist, the upgrade wins unless the user says otherwise. Run `/z doctor` to see what is present.

## Smallest change (code rule)
Whoever writes code does the least that fully solves the task, in this order: skip it if it needn't exist; reuse what the codebase already has; use the standard library or platform; use an installed dependency; then write the minimum. No abstraction, option or "for later" code nobody asked for. Never cut validation at trust boundaries, error handling, security or accessibility. Find every caller, test and fixture the change touches and update them. New non-trivial logic gets one small test. Reviewers flag code that ignores this. (Optional upgrade: the `ponytail` plugin, by DietrichGebert.)

## Think: sharpen the idea
(Optional upgrade: gstack `/office-hours`.) With the researcher's findings in hand, write a design note in `docs/designs/<slug>.md`:
1. **Problem** in one sentence, and who has it.
2. **Evidence** it is real: what people do today, what it costs them.
3. **Narrowest useful version**: the smallest thing that solves it for one person.
4. **The one bold idea** that makes it better than the alternatives.
5. **Reuse vs build**: what exists that we adopt.
6. **Risks and unknowns**, each with the cheapest way to test it.
`guided`: walk the user through these as questions, one at a time, challenging vague answers. `full`: answer them yourself from the request and research, and log the assumptions.

## Plan review
(Optional upgrade: gstack `/autoplan`, `/plan-eng-review`, `/plan-design-review`.) Read the plan and answer, in writing, in the design note:
- **Scope:** is anything in it nobody asked for? Is anything asked for missing? Is there a version half the size?
- **Architecture:** data flow, boundaries, what happens at each failure (timeout, bad input, partial write, concurrent use).
- **Contradictions:** does any requirement conflict with a constraint or another requirement? Does any step assume something unchecked (a tool, an OS, an API)?
- **Tests:** what proves each acceptance criterion?
- **UI work:** hierarchy, states (empty, loading, error), phone width, keyboard and screen-reader use.
Run the `reviewer` on the plan file in fresh context as an outside voice and record its findings.

## Gate check (weakened checks)
(Optional upgrade: gstack `gstack-gate-diff`.) List what the diff weakens:
`git add -N . && git diff --merge-base <base> -U0 | grep -vE '^(\+\+\+|---) ' | grep -niE '^\+.*(skip|xit\(|xdescribe|\.only|--no-verify|eslint-disable|@ts-ignore|noqa|nosec|catch *(\([^)]*\))? *\{ *\}|except[^:]*: *pass)|^-.*(assert|expect|def test|func test|test\()'`
Also look by eye for raised timeouts, new retries, and code that behaves differently under test or CI environment variables. Hits are leads, not verdicts: the reviewer decides whether each relaxation silences a real failure.

## Review
(Optional upgrade: gstack `/review`, `/cso`, run report-only; or the `code-review` skill.) The default is the parallel `reviewer`, `security-auditor` and `tester` in z-review. Each reports `file:line`, what is wrong, and a concrete failing input. No findings without a concrete failure.

## QA
(Optional upgrade: gstack `/qa-only`.) Report only, never fix. Run the app (or point at a preview URL) and drive the changed behaviour:
- **Web:** use Playwright (`pip install playwright && playwright install chromium webkit`) or any browser tool you have. Click the real flow, submit empty and hostile input, reload mid-flow, check the console for errors, check 1440, 390 and 320 px.
- **API:** call each changed endpoint with valid, missing, malformed and unauthorised input; check status codes and bodies.
- **CLI/job:** run with good input, no input, bad flags and a missing file; check exit codes and output.
Write `.claude/team/qa-<milestone>.md`: per check, what you did, what you saw, PASS/FAIL, and the evidence (command output or screenshot path).

## Investigate (a bug that resists a quick fix)
(Optional upgrade: gstack `/investigate`, `mattpocock-skills:diagnosing-bugs`.) No fix without a root cause:
1. Reproduce it reliably; write the failing test or command.
2. Shrink: remove inputs and code until it still fails.
3. List causes, test each with one observation (log, debugger, bisect with `git bisect`), and rule them out.
4. State the root cause as one sentence you can prove. Fix that, once, in the shared code. The reproduction now passes.
After three failed hypotheses, stop and report what you ruled out instead of guessing again.

## Ship checklist
(Optional upgrade: gstack `/ship`.) Do by hand, in order:
1. `git fetch`; merge or rebase the base branch; fix conflicts.
2. Run the `Verify:` commands on the branch head and read the output.
3. Check README, docs and CHANGELOG against the diff.
4. Run the pre-PR review (`/z` rules).
5. Push the feature branch; open the PR with what changed, why, and each acceptance criterion as PASS / MANUAL-PASS / CARRIED @ sha. Pending manual rows go in a `- [ ]` list; keep the PR draft while any are pending.
6. Triage review findings once: correctness, data loss, security and concurrency are fixed now; the rest go to `TODOS.md`.

## Learnings
(Optional upgrade: gstack `gstack-learnings-search` and `/learn`.) Keep `.claude/team/learnings.md`: one line per lesson, `pitfall: <what went wrong> → <what to do>` or `pattern: <what worked>`. Read it at the start of every sprint and paste the lines that touch a task into that role's brief. Append to it in Reflect.

## Retro
(Optional upgrade: gstack `/retro`.) Using `git log --since` for the milestone and the role logs, write: what shipped (PRs, commits), what slowed us down (rework, failed gates, waiting), what to change next sprint. Promote durable lessons to learnings.

## Local helper tools
`local-llm` and `local-review` need Ollama. Without it, read logs yourself and go straight to `judge`.
