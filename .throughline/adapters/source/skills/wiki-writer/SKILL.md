---
name: wiki-writer
description: Create or update wiki pages in the standard format — frontmatter, sources, stable ids, index linkage, log entry. Invoke with /wiki-writer.
---

# Wiki Writer Skill

## Purpose
Keep the agent-maintained knowledge base structurally uniform so retrieval skills and the lint command can rely on its shape.

## Page Format

```markdown
# <Title>
**Page ID**: <stable-kebab-slug>
**Scope**: global | target:<id>
**Maintained by**: Archivist
**Last updated**: YYYY-MM-DD
**Sources**: standards/<file>.md §<RULE-ID>; exemplars/<path>; specs/NNN-*/...

<body — facts with citations; link related pages as [[wiki/concepts/<slug>]]>
```

## Algorithm

1. Check `wiki/index.md` for an existing page covering the topic — update it rather than duplicating.
2. Write/update the page preserving its Page ID (ids are stable forever).
3. Every factual claim carries a source citation; claims without sources don't go in the wiki.
4. Add/refresh the `wiki/index.md` entry (one line: link + hook).
5. Append a `wiki/log.md` entry (timestamp, agent, page, action, summary).

## Rules

- Only the Archivist persona may invoke this skill for content writes (constitution §Write-Boundary Invariants); Orchestrator/Auditor use it solely to FORMAT recommendation artifacts outside `/wiki/`.
- Wiki content is derived — on any conflict with `/standards/` or `/exemplars/`, the source wins and the page gets fixed, not the source.
- **Scope** (Constitution Principle II): pages describing one target's internals (its auth flow, its module layout, its quirks) MUST be scoped `target:<id>`; reusable engineering knowledge stays `global` (the default when the field is omitted). Readers ignore pages scoped to a different target. A `target:<id>` scope must reference a registered target.

## Usage Context
Called by: Archivist (ingest, concepts, registries), Orchestrator (exception-registry recording during /dev.review-escalated), Auditor (recommendation formatting).
