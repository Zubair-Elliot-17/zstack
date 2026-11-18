# Changelog

All notable changes are listed here. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versions follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- Claude Code plugin packaging: `.claude-plugin/plugin.json` and `marketplace.json`, and `hooks/hooks.json` (install with `claude plugin install zstack@zstack`).
- `git-readonly.sh auto` mode: one PreToolUse hook restricts `judge` and `local-review` by agent type (plugin agents cannot carry their own hooks).

### Changed
- Skill and agent text refers to `${CLAUDE_PLUGIN_ROOT}`; `install.sh` rewrites it to the install folder for manual installs.

### Removed
- `sync.sh`: the repo is now the source of truth.

## [0.1.0]

First public release: the seven-stage sprint (`/z`, `/z-think` to `/z-reflect`), the `/z-iterate` quick lane, the agent team roles, resumable `STATE.md`, hooks, and the `install.sh` / `sync.sh` scripts.

[Unreleased]: https://github.com/Zubair-Elliot-17/zstack/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Zubair-Elliot-17/zstack/releases/tag/v0.1.0
