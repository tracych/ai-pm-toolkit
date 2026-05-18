# Example KB — Shoplit Recommendations

A worked example of the knowledge-portal structure for a fictional e-commerce recommendations team. Same imaginary team as `team-knowledge/assets/example_brain/` — the two examples are designed to be read together.

## What's here

```
example_kb/
├── README.md                         # this file
├── knowledge_base_architecture.md    # the 10-topic frame, explained for this KB
├── knowledge/
│   ├── domain_knowledge.md
│   ├── systems_and_models.md
│   ├── metrics_and_measurement.md
│   ├── people_and_org.md
│   ├── processes_and_rituals.md
│   ├── gotchas_and_tips.md
│   ├── resources.md
│   ├── skills.md
│   ├── industry_landscape.md
│   ├── intake.md
│   ├── conflict_log.md
│   └── deep_dives/
│       └── candidate_dedup_investigation.md
├── portal/
│   ├── build_portal.py                # (copy from plugin's portal/ — kept here for self-contained runnability)
│   ├── index.html.tmpl
│   ├── explainer.html.tmpl
│   └── explainers/
│       └── two-tower-retrieval.html
└── auto_discovery/
    ├── auto_discovery_playbook.md
    └── auto_discovery_findings.md
```

> **Sync note:** `portal/build_portal.py`, `portal/index.html.tmpl`, and `portal/explainer.html.tmpl` here are **copies** of the files in the plugin's top-level `portal/` directory, kept here so the example is runnable standalone. If you change the upstream, re-copy them. There's no automated sync.

## Try it

```bash
cd portal/
python3 build_portal.py
open index.html       # or xdg-open / start
```

The portal will render this KB end-to-end so you can see exactly what your own KB will look like after `/portal-build`.
