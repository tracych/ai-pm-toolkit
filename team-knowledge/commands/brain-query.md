---
displayName: 'Brain — Query'
description: 'Ask a natural-language question against the team brain. Searches CLAUDE.md, contributors/, reports/published/, and conflict_log.md, with confidence-aware answers and citations.'
---

# /brain-query

The retrieval interface. Usage: `/brain-query "what did the team decide about model X last quarter?"`

## Phase 0 — Parse the question

Identify the question type:
- **Decision** — "what did we decide about…", "why did we choose…"
- **Status** — "where is project X", "who's working on Y"
- **People** — "who knows about X", "who owns Y"
- **History** — "when did we…", "how did we evolve from…"
- **Open** — "what are we unsure about", "what's blocked"

## Phase 1 — Source selection

| Question type | Read order |
|---|---|
| Decision | `CLAUDE.md` Decisions table → `reports/published/*` for context → `contributors/*` Decisions sections |
| Status | `CLAUDE.md` Active Projects → contributors recently active on that project |
| People | `CLAUDE.md` Team + Active Projects (DRI column) → contributors with most activity on the topic |
| History | `reports/published/*` chronologically → `CLAUDE.md` Decisions |
| Open | `CLAUDE.md` Open Questions → `intake.md` pending → `conflict_log.md` |

## Phase 2 — Answer with confidence

Structure the response:
1. **Direct answer** — 1-2 sentences
2. **Confidence** — HIGH / MED / LOW based on:
   - How many sources corroborate
   - Whether it came from CLAUDE.md (moderated) vs intake (pending) vs contributors (raw)
   - Whether `conflict_log.md` has a related contradiction
3. **Citations** — file path + section, with the literal text quoted
4. **Caveats** — if anything in `conflict_log.md` touches this topic, surface it

## Phase 3 — Honesty floor

If you can't find the answer, say so explicitly. Do not synthesize from adjacent topics. Suggest:
- A `/brain-ingest --since 30d --contributor <username>` if a likely-relevant contributor's `last_sync` is stale
- A manual edit to `intake.md` if the user already knows the answer and the brain should learn it
- A check of `conflict_log.md` if the topic recently had a contradiction

## Example

```
> /brain-query "why did we move PASE to a separate experiment slot?"

ANSWER: To reduce control dilution from 39% on the shared experiment slot.
CONFIDENCE: HIGH
SOURCES:
  - CLAUDE.md #key-decisions (row 2026-03-24)
  - contributors/alice.md #decisions (2026-03-24)
  - reports/published/2026-03-25.md
CAVEATS: none
```
