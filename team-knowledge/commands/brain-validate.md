---
displayName: 'Brain — Validate'
description: 'Run cross-validation + adversarial validation on entries in intake.md. Promotes confidence, demotes weak claims, surfaces contradictions to conflict_log.md.'
---

# /brain-validate

Optional pass between `/brain-evolve` and `/brain-moderate`. Catches: (1) claims one source asserted but others contradict, (2) claims that *sound* HIGH-confidence but rest on a summary-of-summary.

## Phase 0 — Read inputs

- `intake.md` → all proposed additions/updates from the most recent evolve
- `contributors/*.md` → for cross-checking the source claims
- `reports/_source-log/` → raw artifacts, for traceback to primary source
- `prompts/adversarial_validation.md`, `prompts/confidence_rubric.md`, `prompts/conflict_detection.md` → load these and follow

## Phase 1 — Cross-validation pass

For each entry in `intake.md`:
1. Identify how many independent contributors mentioned it. (Two contributors who linked the same doc count as ONE source — the doc.)
2. Trace each mention back to its primary source in `reports/_source-log/`.
3. Recompute confidence per `prompts/confidence_rubric.md`. Update the intake row.

## Phase 2 — Adversarial pass

Spawn an adversarial validator agent per `prompts/adversarial_validation.md`. Posture: assume each claim is wrong until corroborated. The validator should:
- For positive claims: find at least one primary-source citation OR mark `UNFOUND` (default is NOT to confirm)
- For negative claims ("no team owns X", "we don't have Y"): require active search across ≥3 query variations showing absence
- Flag any claim whose source is a *summary* of another source (the summary may have introduced drift)

Validator output writes to `intake.md` as a new column: `Validator verdict` ∈ {CONFIRMED, REFUTED, UNFOUND, NEEDS-PRIMARY-SOURCE}.

## Phase 3 — Resolve

Walk verdicts:
- **CONFIRMED** → leave in intake at current confidence (or bump LOW→MED)
- **UNFOUND** → demote one notch (HIGH→MED, MED→LOW); leave in intake
- **REFUTED** → remove from intake, write to `conflict_log.md` with both the claim and the refutation
- **NEEDS-PRIMARY-SOURCE** → leave in intake but mark `⚠ awaiting primary source`

## Phase 4 — Summary

```
validate complete:
  9 entries reviewed
  → 4 confirmed (no change)
  → 2 demoted   (HIGH→MED, MED→LOW)
  → 1 refuted   (moved to conflict_log.md)
  → 2 need primary source
next: /brain-moderate
```

## Calibration tip

If most entries come back UNFOUND, your contributor files don't carry enough primary-source links. Update `/brain-ingest` to capture URLs in the source-log JSON, not just summaries.
