# Changelog

Format: [Keep a Changelog](https://keepachangelog.com) · [SemVer](https://semver.org).
The constitution carries its own version; amendments are logged in `wiki/log.md`.

## [0.1.0] — 2026-06-11

Initial public release.

- Spec-driven lifecycle (spec-kit): specify → clarify → plan → tasks → implement → analyze
- Eight single-purpose agent personas with separation of duties and artifact-only handoffs
- `/dev.feature` — one command for existing codebases and greenfield projects (auto-detected)
- 13 `/dev.*` commands; dual-runtime adapters for GitHub Copilot and Claude Code over shared runbooks
- External-target model (`targets/`); reversible changes on `sdd/<slice>` branches; human-only merge
- Confidence-gated review with executed test evidence, source-verified citations, and escalation
- Knowledge layer: machine-readable standards (with optional executable `Tool:` checks), curated
  exemplars, agent-maintained wiki with target scoping and an append-only log
- Write-boundary + Bash-safety hooks (both runtimes, both shells); CI; VS Code dashboard
- Docs: 10-part guide, command reference, architecture, and one validation run
