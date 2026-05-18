# Shoplit Recommendations Brain

> Curated team knowledge base. Auto-proposed updates land in `intake.md` and require human moderation via `/brain-moderate` before reaching this file.

## Context

The Shoplit Recommendations team owns the "for you" feed on the home tab and the "similar items" rail on product pages. Five engineers, weekly release cadence, primary metric is checkout-attributed clickthrough.

## Goal

Lift checkout-attributed CTR on the for-you feed by 8% by end of Q3 without regressing diversity.

## Measurement

| Metric | Current | Target | Timeframe |
|--------|---------|--------|-----------|
| Checkout-attributed CTR (for-you) | 4.1% | 4.4% (+8%) | EOQ3 |
| Category diversity (HHI) | 0.22 | ≤ 0.25 (lower is more diverse) | guardrail |
| p95 retrieval latency | 180ms | ≤ 200ms | guardrail |

## Strategy

Two bets: (1) replace candidate generation co-visitation with a two-tower embedding model; (2) add a re-ranker that uses recent session signal (last 5 viewed items). Either alone is +3-4%; together they're additive.

## Open Questions

- Will the two-tower retrieval model regress cold-start users? Need offline eval cut by user tenure.
- Should the re-ranker run server-side or on-device? Open with infra.

## This Week

- Mira shipped offline eval harness for two-tower model (PR #482).
- Diego closed retrieval p99 spike investigation — caused by stale candidate cache; mitigation rolled out.
- Sam completed feature parity check between v1 and v2 candidate generators.

## Active Projects

| Project | Status | This Period | DRI |
|---------|--------|-------------|-----|
| Two-tower retrieval v2 | ON_TRACK | Offline eval harness shipped; first model train kicked off | mchen |
| Session re-ranker | ON_TRACK | Design doc landed; impl starting next sprint | dpark |
| Retrieval latency p99 | RESOLVED | Stale-cache root cause fixed in PR #475 | dpark |

## Key Decisions (Last 30 Days)

| Date | Author | Decision | Context |
|------|--------|----------|---------|
| 2026-05-02 | rwest | Use two-tower for retrieval v2 over a single deep cross network | Two-tower is cheaper to serve and easier to A/B in parallel with v1 |
| 2026-05-09 | dpark | Session re-ranker scope limited to top-50 candidates (not full slate) | Latency budget; full-slate re-rank busted p95 in prototype |
| 2026-05-12 | mchen | Offline eval will use NDCG@10 cut by user tenure, not just global NDCG | Avoids hiding cold-start regressions |

## Team

| Person | Role | Focus | Last Active |
|--------|------|-------|-------------|
| rwest | EM | Roadmap, eng reviews | 2026-05-15 |
| dpark | Tech Lead | Re-ranker design, latency | 2026-05-16 |
| mchen | Senior IC | Two-tower model, eval harness | 2026-05-17 |
| sotieno | IC | Candidate gen parity, feature work | 2026-05-15 |

---
*Last moderated: 2026-05-17*
