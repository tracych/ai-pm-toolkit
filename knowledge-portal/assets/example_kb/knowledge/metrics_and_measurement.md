# Metrics and measurement

> What we measure, what counts as a win, what we'll never sacrifice.

## North-star metric

**Checkout-attributed CTR (for-you feed).** A click counts if it leads to a checkout within 7 days. Target: 4.4% by EOQ3 (currently 4.1%).

## Secondary / supporting metrics

| Metric | What it measures | Why |
|---|---|---|
| Session length | Time on home tab | Engagement proxy |
| Repeat visit rate | DAU returning within 7d | Long-term satisfaction proxy |
| Add-to-cart rate | Cart adds per impression | Intent indicator earlier than checkout |
| Cold-start CTR | CTR for users with <5 sessions | Watches for cold-start regression hidden by global numbers |

## Guardrails (do not regress)

| Guardrail | Bound | Action if breached |
|---|---|---|
| Category diversity (HHI) | ≤ 0.25 | Block launch |
| p95 retrieval latency | ≤ 200ms | Block launch |
| p99 retrieval latency | ≤ 500ms | Investigate before launch |
| New seller exposure | ≥ 8% of impressions | Block launch (marketplace health) |

## A/B framework

- All launches go through 1% → 10% → 50% ramp
- Each step requires 7 days of data before promotion
- Minimum sample size per arm: 200K daily users
- Diversity / latency / new-seller guardrails read at every promotion

## How we cut metrics

Always cut by user tenure (cold-start vs returning). A global +2% CTR with a -8% cold-start CTR is a regression. The two-tower v2 eval is currently building this cut as a first-class part of the harness.

## Things that have changed recently

| Date | Change | Why |
|------|--------|-----|
| 2026-05-12 | Eval cut by user tenure made mandatory in offline eval | Catch cold-start regressions earlier |
| 2026-04-15 | Min sample size raised from 100K → 200K daily users per arm | Past two launches had noisy decisions at 100K |

## Open questions

- Do we have a satisfaction metric beyond CTR? UXR keeps asking. Survey-based, candidate is NPS-lite weekly pulse.

---
*Maintainer: rwest*
*Last reviewed: 2026-05-15*
