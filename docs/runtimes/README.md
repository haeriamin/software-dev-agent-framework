# Runtimes: Copilot, Claude Code, or Codex

Throughline is one framework behind three thin adapters. The process, rules, agents, and knowledge are shared and don't depend on which tool you run; each tool just wires them in its own way. Pick whichever one you already use. The commands are the same across all three, and the only real difference is the slash punctuation.

| Tool | Install | Slash syntax | Status | Reach for it if… |
|------|---------|--------------|--------|------------------|
| **GitHub Copilot** (VS Code) | VS Code + Copilot | `/dev.analyze` (dot) | Supported | You live in VS Code |
| **Claude Code** | `claude` CLI / desktop | `/dev:analyze` (colon) | Supported | You want a terminal-native agent |
| **Codex** | `codex` CLI / desktop | `/dev.analyze` (dot) | Preview | You're on OpenAI Codex |

Step-by-step guide for each:

- [Copilot](copilot.md)
- [Claude Code](claude-code.md)
- [Codex](codex.md) (preview, with one runtime behaviour still to verify; see the page)

## The five ways to use it

Every tool supports the same five workflows. They only differ in setup and syntax, and each tool's guide shows them in that tool's exact commands. Here's the shape of them:

1. **One command for the whole lifecycle.** `dev.feature <target> "<desc>"` runs specify, clarify, plan, design (if needed), tasks, scaffold (for greenfield), implement, test, and review, stopping only at the real gates.
2. **Cheaper modes.** `--express` skips the optional approval pauses; `--micro` drops to implement, test, review for a genuinely small change.
3. **Phase by phase.** Drive the lifecycle yourself with `speckit.specify`, `clarify`, `plan`, `tasks`, `implement`, adding `dev.design` or `dev.scaffold` when they apply.
4. **Single commands.** Run `dev.analyze`, `dev.test`, `dev.review`, or `dev.audit` against a target without a full spec.
5. **Knowledge only.** Ingest your standards and examples with `dev.ingest-standards` / `dev.ingest-exemplars`, then call the skills ad hoc.

## Shared concepts

Read these once and they apply on any tool:

- **Targets.** Your code lives at external paths you register; the framework holds only process and knowledge. See [Managing Targets](../03-targets.md).
- **The lifecycle and the one command.** See [Building Features](../04-building-features.md).
- **Gates and the human merge.** Every change is tested, independently reviewed, and merged only by you. See [Quality Gates](../06-quality-gates.md).
- **Every command on one page.** See [COMMANDS.md](../../COMMANDS.md).

Whichever tool you pick, the agents never merge or push. That stays your call.
