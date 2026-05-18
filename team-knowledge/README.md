# team-knowledge

> Build and maintain a self-validating team knowledge base — for any PM or EM team.

Most team knowledge dies in a chat archive or a wiki nobody reads. This plugin gives you a workflow that turns raw signals (PR descriptions, doc edits, chat decisions, meeting notes, tickets) into a curated team brain with explicit conflict tracking, confidence levels, and human-on-the-loop moderation.

It is **methodology + templates only.** No connectors to specific data sources. You wire your own sources (Slack, GitHub, Notion, Linear, Google Docs, whatever) into the `brain-ingest` step using tools you already have. That keeps the plugin neutral and portable.

Pattern origin: extracted from a real team brain serving an ML team of ~40 across three sub-teams, used for onboarding, weekly status synthesis, and decision archeology.

---

## Install

```bash
cd ~/code
git clone https://github.com/tracych/ai-pm-toolkit.git

mkdir -p ~/.claude/plugins
ln -s ~/code/ai-pm-toolkit/team-knowledge ~/.claude/plugins/team-knowledge
```

Restart Claude Code. The `/brain-*` slash commands should appear.

---

## Quickstart

```bash
# 1. Scaffold a brain for your team
/brain-init

# 2. Define your sources (edit team-config.yaml)
#    — list teammates and where their work lives

# 3. Ingest recent activity into per-contributor files
/brain-ingest --since 7d

# 4. Roll contributors up into the team CLAUDE.md
/brain-evolve

# 5. (optional) Run validation pass to detect contradictions
/brain-validate

# 6. (when ready) Walk new entries through the moderation queue
/brain-moderate

# 7. Ask the brain questions later
/brain-query "what did the team decide about X last quarter?"
```

---

## How it works — the four design ideas

### 1. Three-layer storage

```
your-team-brain/
├── team-config.yaml        # roster + source schema (where each person's work lives)
├── CLAUDE.md               # curated team brain (the human-readable truth)
├── contributors/           # one file per teammate, auto-synced
│   └── alice.md            # deliverables, decisions, blockers, docs
├── intake.md               # proposed additions awaiting human review
├── conflict_log.md         # detected contradictions, never auto-resolved
└── reports/
    ├── _source-log/        # raw artifacts pulled from sources
    ├── moderated/          # human-reviewed, awaiting publish
    └── published/          # included in the team brain
```

The team `CLAUDE.md` is **curated**, not auto-generated. The auto-generated layer lives in `contributors/`. This split is what makes the brain trustworthy — auto-ingest never overwrites human-curated content.

### 2. Declarative compaction

Each contributor file has compaction rules inline as HTML comments:

```markdown
## Deliverables
<!-- Compacted after 14 days. -->

## Decisions
<!-- NEVER compacted. -->

## Blockers
<!-- NEVER compacted. -->
```

This means `/brain-evolve` knows what to roll up vs. what to preserve forever — without needing a side-channel config.

### 3. Validation before publish

Two validation passes happen between ingest and publish:
- **Cross-validation** — same fact found in N independent sources → confidence rises
- **Adversarial prompting** — agent tries to *refute* each claim, not confirm it. Polite validators miss reversals.

Results write to `conflict_log.md` (contradictions) or `intake.md` (new claims awaiting human review). Nothing reaches the team `CLAUDE.md` until a human moderates.

See `prompts/adversarial_validation.md` and `prompts/confidence_rubric.md`.

### 4. Human-on-the-loop, not human-in-the-loop

The brain runs autonomously between checkpoints. Humans intervene at three points:
- **Source config** — declare what to watch
- **Moderation** — accept/reject/edit proposed entries
- **Conflict resolution** — resolve contradictions the validator flagged

Literal `NEEDS HUMAN INPUT` markers signal where intervention is required.

See `playbooks/human_in_the_loop.md`.

---

## What's in each folder

| Folder | What's inside |
|---|---|
| `commands/` | The 6 `/brain-*` slash commands |
| `templates/` | Drop-in `.tmpl` files for the brain skeleton |
| `playbooks/` | Methodology docs — `auto_discovery`, `human_in_the_loop`, `validation`, `memory_optimization` |
| `prompts/` | Reusable prompts — `adversarial_validation`, `confidence_rubric`, `conflict_detection` |
| `assets/example_brain/` | A small worked example for a fictional "Shoplit Recommendations" team |

---

## Pair with `knowledge-portal`

`team-knowledge` produces a markdown-only team brain. The sibling [`knowledge-portal`](../knowledge-portal/) plugin generates a browsable HTML portal from that markdown — useful for stakeholders who don't read raw markdown or for onboarding new team members.

You can use either independently.

---

## License

[MIT](../LICENSE)
