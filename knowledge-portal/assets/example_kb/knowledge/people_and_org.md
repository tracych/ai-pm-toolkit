# People and org

> Who owns what. Who to ask. Decision authority.

## Team

| Person | Role | Owns | Best for questions about |
|---|---|---|---|
| rwest | EM | Roadmap, prioritization, x-team | Strategy, dependencies, leadership escalation |
| dpark | Tech lead | Re-ranker, latency, infra | Architecture, perf, on-call handoff |
| mchen | Senior IC | Two-tower v2, eval | Modeling tradeoffs, eval design |
| sotieno | IC | Candidate gen parity, feature plumbing | Feature pipelines, dataset questions |

## Decision authority

| Decision | Who decides | Who must sign off |
|---|---|---|
| Model architecture | mchen (with dpark on perf implications) | rwest reviews |
| Latency budget changes | dpark | rwest + infra partner |
| Metric definition changes | rwest | DS partner |
| Launch / hold | rwest | DS partner (statistical), infra (perf) |
| Cold-start strategy | rwest | UXR partner |

Anything not on this list defaults to "the most senior IC closest to the work."

## Partner teams

| Team | Why we work with them | Primary contact |
|---|---|---|
| Search | Our queries downstream feed their candidate set | their PM |
| Ads ranking | Our output is their input | their TL |
| Catalog | They own the SKU metadata we depend on | their PM |
| Infra (serving) | They run the inference layer | their EM |
| UXR | User satisfaction beyond CTR | our embedded researcher |
| Data Science | Experiment readouts | rwest's DS partner |

## Skip-level + chain

rwest → engineering director (skip) → VP eng

Skip-level is open for any IC; book directly.

## Things that have changed recently

| Date | Change | Why |
|------|--------|-----|
| 2026-04 | sotieno joined from infra team | Backfill from previous IC departure |
| 2026-03 | Embedded UXR researcher added | Investing in non-CTR satisfaction signal |

## Open questions

- Should we have a dedicated PM? Currently rwest covers both EM and PM. Decision pending hiring approval.

---
*Maintainer: rwest*
*Last reviewed: 2026-05-15*
