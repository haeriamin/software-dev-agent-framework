# Using the framework with Codex (preview)

Codex uses the **dot** syntax: `/dev.analyze`, `/speckit.specify`.

> **Preview.** All adapter files are in place (`.codex/`), but one runtime behaviour still needs
> confirming on your machine — whether the Orchestrator can autonomously spawn an *isolated*
> Reviewer subagent. See [Verifying the runtime](#7-verifying-the-runtime-preview) below. Until
> then, you can still run every command; you may just need to invoke personas individually.

## 1. What you need
- **Codex CLI** (or the Codex desktop app). On a machine with **no Node**, install the prebuilt
  binary from the [Codex releases](https://github.com/openai/codex/releases) (or `winget` / `scoop`)
  — avoid `npm i -g`.
- A signed-in Codex: `codex login` (ChatGPT) or an `OPENAI_API_KEY`.
- **git**.

## 2. One-time setup
```bash
git clone <repo-url> throughline
cd throughline
codex                       # AGENTS.md + .codex/ assets load from the repo
/hooks                      # trust the project's write-safety hooks (once)
```
Codex reads **custom slash commands from `~/.codex/prompts/` (global)**, so expose the framework's
commands by copying them once:
```bash
cp .codex/prompts/*.md ~/.codex/prompts/        # or symlink; start a new session to pick them up
```
What loads: personas (`.codex/agents/*.toml`), global rules (`AGENTS.md`), hooks
(`.codex/hooks.json`). Details: [.codex/README.md](../../.codex/README.md).

## 3. First run (compile the knowledge — once)
```
/speckit.constitution        # review the framework's law; fill the Ratified date
/dev.ingest-standards        # compile /standards/ into the wiki
/dev.ingest-exemplars        # compile /exemplars/ into the pattern library
```

## 4. Register your code (a "target")
```
/dev.target register path/to/my-app           # existing codebase
/dev.target register path/to/new-app --new     # brand-new project
```
Run Codex from a directory that can reach the target path (its sandbox governs what it may write;
the personas' `sandbox_mode` keeps read-only roles read-only).

## 5. The five ways to use it

**a) One command — whole lifecycle:**
```
/dev.feature my-app "Add cursor pagination to the orders endpoint"
```

**b) Cheaper modes:**
```
/dev.feature my-app "Rename the config flag" --micro      # implement → test → review only
/dev.feature my-app "Add a log line" --express             # skip the optional approval pauses
```

**c) Phase-by-phase (full control):**
```
/speckit.specify "Add pagination to orders (target: my-app)"
/speckit.clarify
/speckit.plan
/speckit.tasks
/speckit.implement
```

**d) Single commands (out-of-band, no full spec):**
```
/dev.analyze my-app
/dev.review <slice-id>
/dev.test <slice-id>
/dev.audit
```

**e) Knowledge only:** just steps 3 + the skills used ad hoc.

## 6. Codex-specific notes
- **Slash syntax is dot:** `/dev.analyze`, `/speckit.specify`.
- Personas are `.codex/agents/*.toml`; their `sandbox_mode` enforces the read/write posture.
- Codex has **no declarative handoffs** — the Orchestrator names and spawns each persona; handoffs
  are stated in the persona text.
- Commands live globally in `~/.codex/prompts/` (re-copy after you change `.codex/prompts/`).

## 7. Verifying the runtime (preview)
Before relying on full automation, run the spike in
[.codex/VERIFICATION.md](../../.codex/VERIFICATION.md): ask the Orchestrator to have the Tester
then Reviewer handle a throwaway slice, and confirm it spawns a **separate, isolated Reviewer
subagent** on its own. If it does, Codex is on par with the other runtimes. If spawning is only
manual, run the personas individually (`/dev.test`, then `/dev.review`) — the gates still hold,
you just drive the handoffs yourself.

Next: [Building Features](../04-building-features.md) · [Quality Gates](../06-quality-gates.md)
