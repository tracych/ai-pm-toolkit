# Systems and models

> What's in production today. How the pieces fit together. Where the wires are.

## Explainers

- [Two-tower retrieval](../portal/explainers/two-tower-retrieval.html)

## Architecture

```
request → candidate generator → re-ranker → diversity rebalancer → response
            (top ~500)             (top ~100)     (top 50)
```

Three stages, three different models, three different teams' work shows up at each.

## Candidate generator

| | |
|---|---|
| Status | v1 in production, v2 in training |
| Type | v1: co-visitation graph. v2: two-tower neural retrieval |
| Owner | mchen (v2), dpark (v1 maintenance) |
| Latency | v1: ~40ms. v2 target: <60ms |
| Notes | v2 launch target is mid-June. v1 stays online for control arm during A/B. |

## Re-ranker

| | |
|---|---|
| Status | Sessionless v1 in production. Session-aware v2 in design |
| Type | Gradient-boosted (LightGBM), 142 features |
| Owner | dpark |
| Latency | ~80ms |
| Notes | Session re-ranker (v2) limited to top-50 candidates only — full-slate re-rank busted p95. |

## Diversity rebalancer

| | |
|---|---|
| Status | Stable, rarely touched |
| Type | Greedy MMR-style rebalancing for category HHI |
| Owner | rwest (no active maintainer) |
| Latency | <10ms |
| Notes | Tuned for HHI ≤ 0.25 (lower = more diverse). Hard guardrail. |

## Things that have changed recently

| Date | Change | Why |
|------|--------|-----|
| 2026-05-16 | Stale candidate cache invalidation fix (PR #475) | Caused recurring p99 spikes |
| 2026-05-10 | Two-tower training script committed (PR #471) | First infra for v2 |
| 2026-04-30 | Diversity threshold tightened from 0.30 → 0.25 | UXR feedback on "same-store" feeling |

## Open questions

- Should v2 candidate generator unify the for-you and similar-rail use cases? Currently both call into v1 with different inputs.
- Re-ranker server-side vs on-device — open with infra team.

---
*Maintainer: dpark*
*Last reviewed: 2026-05-16*
