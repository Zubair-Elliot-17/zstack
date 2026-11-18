# Contributing to zstack

Thanks for wanting to help. Forks are welcome: take zstack and make it yours.

To get a change into this repo:

1. **Fork** the repo and create a branch (`fix/<slug>` or `feat/<slug>`).
2. Keep the change small: one stage, role or hook per PR. Stage skills are short on purpose; a PR that makes one longer should say why.
3. **Open a pull request** against `main` and fill in the template.
4. **The maintainer reviews every PR.** `main` is protected: nothing merges without an approving review from [@Zubair-Elliot-17](https://github.com/Zubair-Elliot-17) (enforced by `CODEOWNERS`). Direct pushes to `main` are blocked.

## Commits and releases

- Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/): `feat:`, `fix:`, `docs:`, `chore:`, `ci:`, `refactor:`. Imperative, under 72 characters.
- PRs are squash-merged, so the PR title becomes the commit on `main` and should follow the same format.
- User-visible changes get a line under `[Unreleased]` in `CHANGELOG.md`. Releases are tagged `vX.Y.Z` (SemVer).
- CI runs ShellCheck and an install smoke test; both must pass.

Bigger ideas (a new stage, a new role, a different sprint shape): open an issue first so we can agree on direction before you build it.

Please don't include secrets, personal paths or private project details in skills, logs or examples.
