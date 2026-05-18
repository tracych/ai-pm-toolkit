# Deep dive: candidate dedup investigation

**Status:** archived
**Last updated:** 2026-04-18
**Originating question:** Why does the v1 candidate generator return duplicate SKUs ~3% of the time?

## Summary (TL;DR)

- v1 returns dup SKUs because co-visitation graph treats variant SKUs (color/size) as distinct nodes.
- Fix lives in dedup post-processing, not in the graph (graph rebuild is too expensive).
- ~3% dup rate causes ~0.4% CTR drag — meaningful but not urgent. Folded into v2 design.

## Context

After a UXR study flagged "I keep seeing the same shirt in different colors right next to each other," dpark and mchen ran a 2-week investigation. Goal: confirm whether the duplication was real, quantify, and decide if it warranted a v1 fix or could wait for v2.

## What we found

- HIGH: ~3% of candidate slates have ≥2 SKUs that share a parent product (color/size variants).
- HIGH: the co-visitation graph treats variant SKUs as distinct nodes — by design, since they have separate inventory.
- MED: ~0.4% CTR drag from the duplicates (estimated from a small-scale dedup A/B; sample size limited).
- LOW: users may *prefer* seeing variants sometimes (e.g. shoes — "show me the colors"). Not all duplicates are bad. Inconclusive from UXR.

## What we didn't find

- Whether variant duplication helps in some categories (apparel) and hurts in others (electronics) — would need category-cut A/B.

## Implications

- v1: implement dedup-by-parent-SKU as post-processing step. Low risk. (Shipped 2026-04-30 — PR #463.)
- v2 (two-tower): train with parent-SKU as a tie-breaker feature. Built into the eval harness as a new metric.

## Sources

- UXR study transcript
- A/B exp REC-A-2026-04-12
- Co-visitation graph code at services/recs/cvg/

---

## Archival note

Findings folded into `knowledge/systems_and_models.md` (v1 dedup) and `knowledge/metrics_and_measurement.md` (new dedup metric in eval). Keeping this dive for audit trail.
