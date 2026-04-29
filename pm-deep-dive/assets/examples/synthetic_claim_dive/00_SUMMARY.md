# Synthetic claim dive — what good looks like

**Synthetic example for documentation.** Names and sources are fictional. Shows what a `/pm-deep-dive` claim-pressure-test output looks like.

---

# Sparse training signal is the binding constraint on Quality Model X — Validated Synthesis

**Question:** Sparse training signal (not model architecture or compute) is the binding constraint on Quality Model X's accuracy ceiling.
**Date:** 2026-04-28
**Method:** 6 parallel research agents + 1 code validator + 1 knowledge re-validator (deep depth)
**Domain maturity:** established — HIGH bar requires code/data validation
**Companion files:** 01_industry_competitive.md, 02_internal_owners.md, 03_problem_framing.md, 04_measurement.md, 05_adjacent_tech.md, 06_user_research.md, validation_code.md, validation_knowledge.md

## Verdict on the claim

**CONFIRMED.** Six orthogonal angles + adversarial code validation converge on the same finding: signal sparsity (not architecture, not compute) explains the accuracy plateau. Two new architecture experiments in the past quarter showed <1% lift; two signal-augmentation experiments showed 4–7% lift. Validator confirmed via direct experiment results in the codebase.

## TL;DR

Quality Model X has plateaued at ~82% accuracy for three consecutive quarters despite shipping two new architecture variants and a 3x compute scale-up. Cross-angle research shows the same plateau pattern in two peer models (Model Y, Model Z) — all share the same upstream signal pipeline. Two recent signal-augmentation experiments (LLM-judged labels, weak supervision) showed 4–7% accuracy lift in offline eval. Code validation confirmed via experiment IDs E12345 and E67890. Recommend pivoting Q3 investment from architecture R&D to signal augmentation.

## Cross-validation matrix

| # | Claim | Cross-validation | Confidence | Validator |
|---|-------|------------------|-----------|-----------|
| 1 | Architecture experiments show <1% lift | 01 + 02 + 04 ✓✓✓ | HIGH | CONFIRMED (E11111, E22222) |
| 2 | Signal-augmentation experiments show 4–7% lift | 02 + 03 + 04 ✓✓✓ | HIGH | CONFIRMED (E12345, E67890) |
| 3 | Peer models share the upstream signal pipeline | 02 + 03 ✓✓ | HIGH | CONFIRMED via code path |
| 4 | Compute scaling alone yielded <0.5% lift | 02 + 04 ✓✓ | MEDIUM | CONFIRMED (E33333) |
| 5 | LLM-judged labels are production-viable at scale | 05 ✓ | MEDIUM | UNFOUND |

## High-confidence findings

1. **Architecture is not the bottleneck.** Two new variants (V4, V5) shipped in the past quarter, each with <1% accuracy lift. Compute 3x scale-up yielded <0.5%. The plateau is structural, not architectural.
2. **Signal augmentation moves the needle.** LLM-judged label experiment (E12345) showed 4% lift; weak-supervision experiment (E67890) showed 7%. Both are below production thresholds but directionally clear.
3. **Two peer models exhibit the same plateau.** Model Y and Model Z plateaued at similar accuracies despite different architectures. Common factor: same upstream signal pipeline. This is a portfolio-level constraint, not a single-model issue.

## Validation gap

- "LLM-judged labels production-viable at scale" (#5) is single-sourced from one offline experiment. Production scale requires latency + throughput validation. Knowledge re-validator surfaced two relevant post-mortems from peer teams attempting similar.
- The 4–7% lift range is offline; online lift typically degrades 30–50%. Real production gain expected at 2–4%.

## Suggested follow-ups

1. Scope a Q3 signal-augmentation workstream with the upstream signal-pipeline team
2. Read the two peer post-mortems surfaced by the knowledge re-validator before committing to LLM-judged-label production rollout
3. Design online A/B for the 4% signal-augmentation experiment to confirm online lift
4. Brief leadership on the architecture-vs-signal pivot before Q3 planning

---

*Built with `/pm-deep-dive`. Audit trail in companion files.*
