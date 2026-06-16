# Using the framework with Claude Code

Claude Code uses the **colon** syntax: `/dev:analyze`, `/speckit:specify`.

## 1. What you need
- **Claude Code** (CLI or desktop).
- **git** (for the framework repo and reversible target changes).

## 2. One-time setup
```bash
git clone <repo-url> throughline
cd throughline
claude                      # CLAUDE.md and .claude/ assets load automatically
```
On launch it loads `CLAUDE.md` (the rules), the subagents (`.claude/agents/`), the commands
(`.claude/commands/`), and the write-safety hooks (`.claude/settings.json`). No build step.

## 3. First run (compile the knowledge — once)
```
/speckit:constitution        # review the framework's law; fill the Ratified date
/dev:ingest-standards        # compile /standards/ into the wiki
/dev:ingest-exemplars        # compile /exemplars/ into the pattern library
```
The shipped `/standards/` + `/exemplars/` are replaceable seeds — swap your team's in and re-run.

## 4. Register your code (a "target")
```
/dev:target register path/to/my-app           # existing codebase
/dev:target register path/to/new-app --new     # brand-new project
```
This writes `targets/<id>.yml` and grants Claude Code access to that external path via
`.claude/settings.local.json` (`additionalDirectories`, machine-local + gitignored). No separate
workspace needed — Claude Code edits the registered path directly.

## 5. The five ways to use it

**a) One command — whole lifecycle:**
```
/dev:feature my-app "Add cursor pagination to the orders endpoint"
```
Runs specify → clarify → plan → (design if HIGH) → tasks → implement → test → review, pausing
only at gates. Empty target → greenfield mode (adds design + scaffold).

**b) Cheaper modes:**
```
/dev:feature my-app "Rename the config flag" --micro      # implement → test → review only
/dev:feature my-app "Add a log line" --express             # skip the optional approval pauses
```

**c) Phase-by-phase (full control):**
```
/speckit:specify "Add pagination to orders (target: my-app)"
/speckit:clarify        # answer up to 3 questions
/speckit:plan           # auto-runs /dev:analyze; /dev:design if HIGH/CRITICAL
/speckit:tasks
/speckit:implement      # chains /dev:implement → /dev:test → /dev:review
```

**d) Single commands (out-of-band, no full spec):**
```
/dev:analyze my-app                # understand the codebase
/dev:review <slice-id>             # gate a change: PASS / CONDITIONAL_PASS / FAIL
/dev:test <slice-id>               # author + run tests, record real evidence
/dev:audit                         # portfolio-wide quality roll-up
```

**e) Knowledge only:** just steps 3 + the skills used ad hoc.

## Claude-Code-specific notes
- **Slash syntax is colon:** `/dev:analyze`, `/speckit:specify`.
- The Orchestrator delegates each phase to a **subagent** (Analyst, Implementer, Tester,
  Reviewer, …) via the Agent tool, so the Reviewer stays an independent context.
- Target access is per-machine (`.claude/settings.local.json`) — re-register on a new machine.

Next: [Building Features](../04-building-features.md) · [Quality Gates](../06-quality-gates.md)
