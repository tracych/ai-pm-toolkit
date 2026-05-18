---
displayName: 'Brain — Moderate'
description: 'Walk intake.md interactively — accept, edit, or reject each proposed entry. Accepted entries are written into the team CLAUDE.md and moved to reports/published/.'
---

# /brain-moderate

The human-on-the-loop checkpoint. Walk each pending intake entry one at a time. Nothing reaches `CLAUDE.md` without going through here.

## Phase 0 — Read inputs

- `intake.md` → proposed additions + updates
- `CLAUDE.md` → current curated state
- `conflict_log.md` → for reference; surface counts but don't process here

## Phase 1 — Walk entries

For each entry in intake (HIGH first, then MED, then LOW):

1. Show the entry: confidence, section, content, validator verdict, contributor sources.
2. Ask the user: `[a]ccept / [e]dit / [r]eject / [s]kip / [q]uit`.
3. Action:
   - **accept** — append/update CLAUDE.md per the entry's section + type; move the intake row into `reports/moderated/<YYYY-MM-DD>.md` with `decision: accepted`
   - **edit** — prompt for revised text; then accept the revised version
   - **reject** — move to `reports/moderated/<YYYY-MM-DD>.md` with `decision: rejected` and an optional reason
   - **skip** — leave in intake for next time
   - **quit** — stop the loop; remaining entries stay in intake

## Phase 2 — Promote moderated to published

After the loop, move all newly accepted entries from `reports/moderated/<today>.md` to `reports/published/<today>.md`. (Two-stage: moderated = "decision made", published = "live in CLAUDE.md".)

## Phase 3 — Update brain-meta

Update `brain-meta.json`:
- `last_moderated_at` → now
- `accepted_count`, `rejected_count` → running totals

## Phase 4 — Summary

```
moderate complete:
  6 accepted   → CLAUDE.md updated, reports/published/2026-05-18.md
  2 edited     → accepted with revisions
  3 rejected   → reports/moderated/2026-05-18.md
  1 skipped    → stays in intake
```

## Edge cases

- **CLAUDE.md merge conflict**: if two accepted entries touch the same row in the same section (e.g., two updates to the same project's status), pause and ask the user to pick or merge manually. Do not silently last-write-wins.
- **Reject with reason "wrong section"**: re-route to the correct section instead of rejecting outright.
- **Multiple sessions in a day**: append to the existing `reports/moderated/<today>.md` rather than overwriting.
