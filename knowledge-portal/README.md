# knowledge-portal

> Curated markdown knowledge base + browsable HTML portal generator. For any PM/EM team.

Pairs with [`team-knowledge`](../team-knowledge/). Where `team-knowledge` answers "what is happening on this team right now," `knowledge-portal` answers "what is the durable knowledge of this domain that a new teammate needs."

The output is a **single self-contained HTML file** (no CDN, no build server, no JS framework). Drop it on any static host, attach it to an email, share via a link in chat — it just works.

---

## Install

```bash
cd ~/code
git clone https://github.com/tracych/ai-pm-toolkit.git

mkdir -p ~/.claude/plugins
ln -s ~/code/ai-pm-toolkit/knowledge-portal ~/.claude/plugins/knowledge-portal
```

Restart Claude Code. The `/portal-*` slash commands should appear.

---

## Quickstart

```bash
# 1. Scaffold a knowledge base in the current folder
/portal-init

# 2. Fill in the 10 topic markdowns + any deep dives
#    (edit knowledge/*.md by hand or with /portal-add-topic helpers)

# 3. Add subject-specific explainers (one HTML page per system/metric/etc.)
/portal-add-explainer "Two-tower retrieval"

# 4. Build the portal
/portal-build
# → portal/index.html  (open in any browser, share anywhere)
```

---

## The 10-topic structure

```
knowledge/
├── domain_knowledge.md           # what this domain is, key vocabulary
├── systems_and_models.md         # what's deployed, how they fit together
├── metrics_and_measurement.md    # what we measure and why
├── people_and_org.md             # who does what, reporting chains
├── processes_and_rituals.md      # how decisions get made, release cadence
├── gotchas_and_tips.md           # the "I wish someone had told me" file
├── resources.md                  # canonical links — docs, dashboards, runbooks
├── skills.md                     # AI/automation skills the team uses
├── industry_landscape.md         # external context — competitors, papers, trends
├── intake.md                     # proposed additions awaiting review
├── conflict_log.md               # tracked contradictions
└── deep_dives/
    └── *.md                      # one-off deep dives, lifecycle-tagged
```

This shape didn't come from nowhere. It's the 10 buckets that consistently show up when you onboard someone new — "what's it about," "what runs," "what we measure," "who to ask," "how things get done," "what'll burn me," "where do I look," "what tools to use," "what's happening outside," and "where do new items go."

Use all 10 or trim — but resist adding more. The shape is the point.

---

## How it differs from a wiki

| Wiki | knowledge-portal |
|---|---|
| Many small pages, weak structure | Few large pages, strict structure |
| Search-first navigation | Topic-first navigation |
| Many editors, many writing styles | One editorial voice per topic |
| Edits are page-level | Edits go through `intake.md` if you also use team-knowledge |
| HTML rendered by wiki engine | HTML rendered by `build_portal.py` from your markdown |
| Lives in a SaaS | Lives in your repo / drive — portable |

If you have a wiki you like, keep it. This is for teams who want their knowledge in git/drive next to their code.

---

## What's in each folder

| Folder | What's inside |
|---|---|
| `commands/` | The 4 `/portal-*` slash commands |
| `templates/` | Starter markdown for each topic |
| `portal/` | `build_portal.py` (zero deps, stdlib only) + HTML templates |
| `playbooks/` | `kb_structure` (why 10 topics), `kb_maintenance` (when to update) |
| `assets/example_kb/` | A worked example for the same fictional "Shoplit Recommendations" team |

---

## Pair with `team-knowledge`

The `intake.md` and `conflict_log.md` in this plugin mirror the same files in `team-knowledge`. If you use both, point them at the same files — durable knowledge gets curated here, current activity gets curated there.

---

## License

[MIT](../LICENSE)
