# Gotchas and tips

> The "I wish someone had told me" file. The most valuable page in the KB. Read every couple of weeks.

## Modeling

- **Don't trust global CTR cuts.** A +2% global with -8% cold-start is a regression. Always cut by user tenure.
- **Candidate cache stales silently.** TTL is 12 hours but invalidation paths have failed historically (see PR #475). If retrieval starts looking weird, check cache age first.
- **Two-tower scores aren't comparable across runs.** Training stochasticity. Always compare within-run; for cross-run, use ranking-based metrics (NDCG, MRR).
- **Diversity rebalancer can hide a bad re-ranker.** A re-ranker producing 10 same-category items will *look* fine in the final slate because the rebalancer fixes it. Always eval the re-ranker output *before* rebalancing.

## Infra / serving

- **p99 retrieval is the canary.** Watch it.
- **GPU memory leaks happen on every restart for 5-10 minutes.** Don't deploy mid-business-hours; deploy at 02:00 local.
- **Feature pipeline lag is real.** A "new" feature in the offline data may be 6 hours stale in serving. Always check pipeline lag dashboard before A/B reads.

## Process

- **The async standup in chat is the source of truth for blockers.** If you only mention a blocker in DM with the EM, it won't get unblocked.
- **Eng review on Wed is optional but underused.** If you're stuck on a design choice, bring it. The empty room is more your problem than ours.
- **"Reversible" decisions can become irreversible** once they're in production for 30 days (users adapt). Categorize before launch, not after.

## Communication

- **Don't ping infra in our chat space; they have their own.** Tag the infra partner in their channel.
- **Leadership wants weekly deltas, not weekly status.** "We shipped X" is not interesting; "We shipped X *and* it moved Y by Z%" is.

## Things that have changed recently

| Date | Change | Why |
|------|--------|-----|
| 2026-05-16 | Candidate cache gotcha added | After PR #475 fix; want future maintainer to know the failure mode |
| 2026-04-22 | Async standup gotcha added | Two ICs got stuck for >1 week on blockers only mentioned in DM |

---
*Maintainer: dpark*
*Last reviewed: 2026-05-16*
