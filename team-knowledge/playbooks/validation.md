# Validation playbook

Two validation modes the plugin uses, and when to add each.

## Mode 1: cross-validation (always on)

Run inside `/brain-evolve`. The principle: a claim made by N independent contributors with M independent primary sources is more likely true than the same claim made by one contributor citing one source.

**Independence is the trap.** Two contributors who both link the same doc count as one source — the doc. Two contributors who arrived at the same conclusion *from different artifacts* count as two.

Confidence labeling per `prompts/confidence_rubric.md`:
- HIGH — ≥2 truly independent sources
- MEDIUM — 1 source + corroborating artifact
- LOW — 1 source only

## Mode 2: adversarial validation (optional, recommended)

Run inside `/brain-validate`. The principle: a polite validator confirms; an adversarial validator tries to refute. Reversals only surface under adversarial pressure.

The validator should:
- Default to skepticism
- Require primary source citation for CONFIRMED — not summary-of-summary
- Require active search across multiple query variations for negative claims
- Return UNFOUND by default, not CONFIRMED, when evidence is absent

See `prompts/adversarial_validation.md` for the validator prompt.

## When to add adversarial validation

Skip it if:
- Brain is fresh (<2 weeks of data, validation has nothing to validate)
- Volume is low (<5 entries per intake cycle)
- All sources are first-party primary (e.g., your own PRs only)

Add it if:
- You've shipped something based on the brain and it was wrong
- Multiple sources summarize from a common upstream doc (drift risk)
- Brain feeds external stakeholders (leadership reviews, exec briefs)

## What validation cannot do

- **Cannot validate Goal / Strategy / Measurement** — these are choices, not claims
- **Cannot validate future-tense claims** — "we will" is not refutable until it's "we did"
- **Cannot resolve trust between contradicting first-hand accounts** — that's the human's job in `conflict_log.md`

## Calibration

After a moderation cycle, look at your accept/reject ratio:
- Most rejections are LOW-confidence → cross-validation is calibrated; trim ingest noise
- Most rejections are MED-confidence → cross-validation is over-rating; tighten the source-independence rule
- Rejections include HIGH-confidence → adversarial pass is missing things; review `prompts/adversarial_validation.md`
