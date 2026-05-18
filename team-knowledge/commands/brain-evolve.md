---
displayName: 'Brain — Evolve'
description: 'Roll all contributor files up into proposed updates to the team CLAUDE.md. Writes proposals to intake.md for human moderation — does NOT touch CLAUDE.md directly.'
---

# /brain-evolve

Synthesize per-contributor activity into team-level signals, and propose updates to the team brain.

## Design rule: never auto-write to CLAUDE.md

`CLAUDE.md` is curated. `/brain-evolve` proposes. `/brain-moderate` accepts. This split is what keeps the brain trustworthy.

## Phase 0 — Read inputs

- `team-config.yaml` → roster + slug
- `CLAUDE.md` → current curated state (so we know what's already there)
- `contributors/*.md` → all teammate files
- `conflict_log.md` → known unresolved contradictions (skip rolling these up)

## Phase 1 — Synthesize team-level signals

Walk the contributor files and aggregate. Produce candidate entries for each section of `CLAUDE.md`:

| CLAUDE.md section | What rolls up |
|---|---|
| **This Week** | Top deliverables across all contributors in last 7d |
| **Decisions (last 30d)** | Every contributor `Decision` row in last 30d (verbatim — do not paraphrase) |
| **Active Projects** | Detect project clusters via repeated keywords/tags; assign DRI from most active contributor |
| **Open Questions** | Contributor blockers + open questions from documents |
| **Team** | Roster status — last_sync recency, recent focus area |
| **Goal / Strategy / Measurement** | These never auto-update. They have `NEEDS HUMAN INPUT` markers. |

## Phase 2 — Diff against current CLAUDE.md

For each candidate entry:
- **New** (not in CLAUDE.md): add to `intake.md` under `## Proposed additions`
- **Updates an existing row** (same project/decision key): add to `intake.md` under `## Proposed updates` with a before/after diff
- **Contradicts an existing entry**: do NOT add to intake — instead write to `conflict_log.md` and skip

## Phase 3 — Confidence labels

Tag each candidate with HIGH / MEDIUM / LOW per `prompts/confidence_rubric.md`:
- **HIGH** — ≥2 independent contributors mention it OR explicit decision row OR explicit deliverable with link
- **MEDIUM** — 1 contributor mentions, but corroborating doc or PR exists
- **LOW** — single mention, no corroboration

LOW entries still go to intake but are marked for skeptical review.

## Phase 4 — Write intake + summary

Write to `intake.md`:

```markdown
## Proposed additions
| Confidence | Section | Entry | Source contributors | Detected |
|---|---|---|---|---|

## Proposed updates
| Confidence | Section | Before | After | Source contributors | Detected |
|---|---|---|---|---|---|
```

Print a summary:
```
evolve complete:
  9 proposed additions  (4 HIGH, 3 MED, 2 LOW)
  2 proposed updates    (1 HIGH, 1 MED)
  1 conflict detected   → conflict_log.md
next: /brain-validate    (optional adversarial pass)
  or: /brain-moderate    (walk intake.md)
```

## What NOT to do

- Do not edit `CLAUDE.md` directly
- Do not delete existing CLAUDE.md content
- Do not auto-resolve contradictions
- Do not paraphrase a `Decision` row — copy verbatim
- Do not infer Goal / Strategy / Measurement from contributor data
