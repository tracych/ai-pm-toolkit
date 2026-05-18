# Knowledge base architecture — Shoplit Recommendations

> This KB uses the standard 10-topic frame from the `knowledge-portal` plugin. Below: which topics are heavy/light for this team, and why.

## Topic weight in this KB

| Topic | Weight | Why |
|---|---|---|
| `domain_knowledge` | medium | Stable, slow-changing |
| `systems_and_models` | **heavy** | Active migration (v1 → v2 retrieval) — needs current state captured |
| `metrics_and_measurement` | medium | Stable framework; small additions per quarter |
| `people_and_org` | light | Small team |
| `processes_and_rituals` | medium | Async standup is recent; documented for newcomers |
| `gotchas_and_tips` | **heavy** | Most-read page during incidents and onboarding |
| `resources` | light | Curated to top-N; resist link sprawl |
| `skills` | medium | A handful of shared slash commands |
| `industry_landscape` | light | Reviewed quarterly only |
| `intake` | rolling | Walked weekly by EM |

## Companion: team-knowledge brain

The [team-knowledge brain](https://github.com/tracych/ai-pm-toolkit/tree/main/team-knowledge) and this KB use the **same intake/conflict_log schema** so one moderator can review both with one mental model. The files themselves stay separate — the brain's intake is for team-status changes; this KB's intake is for durable knowledge additions.

## Build pipeline

```
knowledge/*.md  ─┐
deep_dives/*.md ├─→ python3 portal/build_portal.py → portal/index.html
explainers/*.html ─┘
```

Builds in <1 second. Run after any edit to a topic file.

## Maintenance cadence

- Weekly: `rwest` runs intake moderation
- Monthly: each topic maintainer scans their topic for staleness
- Quarterly: full KB review; archive deep dives whose findings have been folded into topics
