# Using the framework with GitHub Copilot (VS Code)

Copilot uses the **dot** syntax: `/dev.analyze`, `/speckit.specify`.

## 1. What you need
- VS Code with **GitHub Copilot** (agent/chat enabled).
- **git** (for the framework repo and reversible target changes).

## 2. One-time setup
```bash
git clone <repo-url> throughline
```
Open the **framework folder** in VS Code. The `.github/` assets load automatically — agents
(`.github/agents/`), instructions (`.github/copilot-instructions.md`), and the write-safety
hooks (`.github/hooks/hooks.json`). No build step.

## 3. First run (compile the knowledge — once)
In Copilot Chat:
```
/speckit.constitution        # review the framework's law; fill the Ratified date
/dev.ingest-standards        # compile /standards/ into the wiki
/dev.ingest-exemplars        # compile /exemplars/ into the pattern library
```
The shipped `/standards/` + `/exemplars/` are replaceable seeds — swap your team's in and re-run.

## 4. Register your code (a "target")
```
/dev.target register path/to/my-app           # existing codebase
/dev.target register path/to/new-app --new     # brand-new project
```
This writes `targets/<id>.yml` and a **multi-root workspace** `targets/<id>.code-workspace`.
**Open that workspace** so Copilot can edit the target alongside the framework.

## 5. The five ways to use it

**a) One command — whole lifecycle:**
```
/dev.feature my-app "Add cursor pagination to the orders endpoint"
```
Runs specify → clarify → plan → (design if HIGH) → tasks → implement → test → review, pausing
only at gates. Empty target → greenfield mode (adds design + scaffold).

**b) Cheaper modes:**
```
/dev.feature my-app "Rename the config flag" --micro      # implement → test → review only
/dev.feature my-app "Add a log line" --express             # skip the optional approval pauses
```

**c) Phase-by-phase (full control):**
```
/speckit.specify "Add pagination to orders (target: my-app)"
/speckit.clarify        # answer up to 3 questions
/speckit.plan           # auto-runs /dev.analyze; /dev.design if HIGH/CRITICAL
/speckit.tasks
/speckit.implement      # chains /dev.implement → /dev.test → /dev.review
```

**d) Single commands (out-of-band, no full spec):**
```
/dev.analyze my-app                # understand the codebase
/dev.review <slice-id>             # gate a change: PASS / CONDITIONAL_PASS / FAIL
/dev.test <slice-id>               # author + run tests, record real evidence
/dev.audit                         # portfolio-wide quality roll-up
```

**e) Knowledge only:** just steps 3 + the skills used ad hoc in chat.

## Copilot-specific notes
- **Slash syntax is dot:** `/dev.analyze`, `/speckit.specify`.
- Use the generated `<id>.code-workspace` — without it Copilot can't reach the target's files.
- Agents hand off to each other via the `handoffs:` defined in `.github/agents/*.agent.md`.
- The dashboard extension ([docs/07](../07-dashboard.md)) gives a live view of the work queue.

Next: [Building Features](../04-building-features.md) · [Quality Gates](../06-quality-gates.md)
