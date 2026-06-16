# Runtimes — using the framework on Copilot, Claude Code, or Codex

The framework is **one brain, three adapters**. The process, rules, agents, and knowledge are
shared and runtime-neutral; each host just wires them in differently. Pick whichever host you
already use — the commands are the same everywhere, only the slash punctuation differs.

| Host | Install | Slash syntax | Status | Pick it if… |
|------|---------|--------------|--------|-------------|
| **GitHub Copilot** (VS Code) | VS Code + Copilot | `/dev.analyze` (dot) | Supported | You live in VS Code |
| **Claude Code** | `claude` CLI / desktop | `/dev:analyze` (colon) | Supported | You want a terminal-native agent |
| **Codex** | `codex` CLI / desktop | `/dev.analyze` (dot) | **Preview** | You use OpenAI Codex |

Per-host, step-by-step guides:
- **[Copilot →](copilot.md)**
- **[Claude Code →](claude-code.md)**
- **[Codex →](codex.md)** (preview — one behaviour still needs verifying, see the page)

## The same five ways to use it (any host)

Every host supports the same usage modes — they only differ in setup and syntax. The per-host
guides show each in that host's exact commands; here is what they are:

1. **One command, whole lifecycle** — `dev.feature <target> "<desc>"` runs specify → clarify →
   plan → (design) → tasks → (scaffold) → implement → test → review, pausing only at gates.
2. **Cheaper modes** — `--express` skips the optional approval pauses; `--micro` collapses to
   implement → test → review for a genuinely small change.
3. **Phase-by-phase** — run the lifecycle yourself: `speckit.specify → clarify → plan → tasks →
   implement`, adding `dev.design` / `dev.scaffold` when needed.
4. **Single commands (out-of-band)** — `dev.analyze`, `dev.test`, `dev.review`, `dev.audit` on a
   target without a full spec.
5. **Knowledge only** — `dev.ingest-standards` / `dev.ingest-exemplars`, then use the skills ad hoc.

## Shared concepts (read once, apply on any host)

- **Targets** — your code lives at external paths you register; the framework holds only process
  and knowledge. See [Managing Targets](../03-targets.md).
- **The lifecycle & the one command** — [Building Features](../04-building-features.md).
- **Quality gates & human merge** — every change is tested, independently reviewed, and only *you*
  merge. See [Quality Gates](../06-quality-gates.md).
- **Every command on one page** — [COMMANDS.md](../../COMMANDS.md).

> Whichever host you choose, the agents never merge or push — that stays your call.
