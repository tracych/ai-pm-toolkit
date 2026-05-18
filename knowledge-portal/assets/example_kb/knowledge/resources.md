# Resources

> Canonical links. Top dashboards, key docs, runbooks. Curated — not exhaustive.

## Dashboards

| Dashboard | What it shows | When to use |
|---|---|---|
| Daily CTR (for-you) | Top-line CTR + guardrails by hour | First thing every morning; before/after every launch |
| A/B experiment dashboard | Live experiment readouts | Promotion decisions |
| Retrieval latency p50/p95/p99 | Latency by stage and model | Pages; weekly capacity review |
| Cold-start segment cuts | CTR by user tenure bucket | Before any launch decision |
| New seller exposure | % impressions from sellers <30d in catalog | Marketplace health guardrail |

(Placeholder URLs — replace with your own.)

## Docs

| Doc | Owner | Purpose |
|---|---|---|
| Team roadmap (Q3) | rwest | What we're committing to |
| Re-ranker design doc | dpark | Architecture + tradeoffs of v2 |
| Eval harness spec | mchen | Offline eval methodology |
| Incident runbook | dpark | What to do during a page |

## Wikis / collections

- Shoplit Recommendations team wiki space
- Cross-team rec systems guild (monthly)
- Shoplit experimentation handbook

## External reading worth bookmarking

- "Two-tower neural networks for retrieval" — recent survey paper
- "Calibration of personalized rankers" — ICML 2025
- Industry blog posts from peer rec teams (curated quarterly in `industry_landscape.md`)

## On-call

- On-call schedule (this week + 4 weeks ahead)
- Page severity definitions
- Escalation tree

## Things that have changed recently

| Date | Change | Why |
|------|--------|-----|
| 2026-05 | Cold-start segment dashboard added | Required for eval cut-by-tenure |
| 2026-04 | Removed 4 stale dashboards from this list | Hadn't been opened in 90d |

---
*Maintainer: rotates monthly*
*Last reviewed: 2026-05-10*
