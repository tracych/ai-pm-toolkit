# Confidence rubric

Read by `/pm-dive-run` (enforced in agent prompts) and `/pm-dive-summarize` (enforced in cross-validation matrix).

## The bar depends on `frame.domain_maturity`

Two modes — pick by `frame.domain_maturity`:
- **`established`** (default) — mature area; code/data should exist if the claim is true. Strict bar: HIGH requires either ≥3 angle agreement OR explicit code-validation confirmation.
- **`new_bet`** — 0→1 area; code may not exist yet. Relaxed bar: HIGH is angle-agreement based, with knowledge re-validator (not code) as the substantiation path. Absence of code is *not* disqualifying.

When in doubt, default to `established` (the more rigorous bar).

## Levels — `established` mode (default)

### HIGH

A finding is HIGH-confidence if **either**:
- ≥3 independent angle agents arrived at the same finding, **or**
- ≥1 angle agent + the adversarial code/knowledge validator CONFIRMED with a primary source citation (file:line, diff ID, fresh wiki/post)

HIGH means: act on this. Quote it to leadership without caveat.

### MEDIUM

- 2 angle agents agree but no validator confirmation
- 1 angle agent + 1 secondary source (analyst report, summary doc)
- Validator returned INFRA-CONFIRMED-NUMBER-UNRESOLVED (structure exists but specific numbers don't)

MEDIUM means: directionally true, but verify before quoting. Goes into `OPEN_QUESTIONS_LOWER_CONFIDENCE.md` with a named next step.

### LOW

- 1 angle agent only
- Inference from indirect evidence
- Contradicted by another angle agent or the validator

LOW means: hypothesis only. Worth investigating further, not worth stating as fact.

## Levels — `new_bet` mode

Code validator is skipped by design (no code to find). Substitute knowledge re-validation as the validator.

### HIGH

- ≥3 independent angle agents agree, **or**
- ≥1 angle agent + knowledge re-validator (`validation_knowledge.md`) confirms with a fresh primary source (UXR study, recent post, customer interview, market data)

HIGH means: act on this. The bar is genuine angle agreement — not code ownership which doesn't exist yet.

### MEDIUM

- 2 angle agents agree
- 1 angle agent + 1 secondary source

### LOW

- 1 angle agent only
- Contradicted by another angle agent or the knowledge re-validator

## Hard rules (apply in BOTH modes)

- **Never** assign HIGH to a single-source claim, even if the source is authoritative. The point of multi-agent research is independence.
- **Always** downgrade if a validator REFUTED a claim, even if 5 angle agents agreed. Refuting evidence trumps narrative.
- **Always** surface reversals (a HIGH claim downgraded by validation) explicitly in `00_SUMMARY.md` under "What validation changed."
- **Negative claims** ("we have no X", "no team owns Y") need substantiation before HIGH. In `established` mode this means code-grounded confirmation; in `new_bet` mode this means deliberate knowledge re-validation with ≥3 query variations. Negative-inference from a single unsuccessful query is fragile in either mode.

## `established`-only rule

- Code validator UNFOUND keeps a claim at MEDIUM. Do not promote to HIGH on un-validated agreement.

## `new_bet`-only rule

- Code validator UNFOUND does NOT downgrade (the validator was skipped by design — UNFOUND is the expected default and carries no signal). Use knowledge re-validator output instead.

## Why HIGH ≥ 3 (and not ≥ 2)

Three independent paths to the same finding is the minimum that meaningfully reduces single-agent failure modes (hallucination, source-bias, prompt-bias). Two can correlate by sharing an upstream source the agents didn't realize was the same; three is harder to fake.

## When the validator is incomplete

If `validation_code.md` (or `validation_knowledge.md` in `new_bet` mode) is partial or failed (transport errors, no results), every claim that *would have* been validated stays at MEDIUM. Do not promote to HIGH on the basis of un-validated agreement. Surface the validation gap loudly in SUMMARY.

A `validation_code.md` containing only `Skipped: domain_maturity=new_bet` is NOT a gap — it's an expected skip. Do not surface it as a validation failure.
