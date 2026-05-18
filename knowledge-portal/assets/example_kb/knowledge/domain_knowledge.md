# Domain knowledge

> What Shoplit Recommendations is, the vocabulary, and the user we serve. Read this first.

## What we do

Shoplit Recommendations powers two surfaces inside the Shoplit shopping app: the "for you" feed on the home tab, and the "similar items" rail on every product page. We rank products from the catalog (~12M SKUs) to maximize the probability the user adds something to cart and checks out.

## Who the user is

The Shoplit user is mobile-first, comes 2-4 times per week, browses 4-6 products per session, and buys once every 8-10 sessions. They have an implicit query (sometimes — "I'm shopping for shoes today") and an explicit history (always — what they've viewed and bought).

## What we're not

- We're not search — search is a sibling team that handles explicit queries.
- We're not ads — ads is a separate ranker downstream of us.
- We're not merchandising — promoted product placements are determined by the merchandising team, not by our model.

## Key vocabulary

| Term | Meaning |
|---|---|
| **For-you feed** | Home-tab personalized product stream |
| **Similar rail** | Product-detail-page horizontal scroll of related items |
| **Candidate generation** | First-stage retrieval (~10K → ~500 items) |
| **Re-ranker** | Second-stage scorer (~500 → final top-50) |
| **Cold-start user** | <5 sessions of history |
| **Cold-start item** | <30 days in catalog, <100 impressions |
| **HHI (category)** | Herfindahl index over categories in a recommended slate; lower = more diverse |
| **CTR-attributed** | Click that led to a checkout within 7 days |

## Things that have changed recently

| Date | Change | Why |
|------|--------|-----|
| 2026-04 | "Similar rail" now contextual to scroll history, not just current item | First-step toward session re-ranker |
| 2026-03 | For-you feed switched from infinite scroll to 50-item slate | Better A/B measurement, lower infra cost |

## Open questions

- Should "for-you" and "similar rail" share a model, or stay separate? Current: separate. Pressure to unify is growing.
- Cold-start strategy — currently fallback to popularity. Worth investing in a tenure-conditioned retrieval?

---
*Maintainer: rwest*
*Last reviewed: 2026-05-15*
