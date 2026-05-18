# ai-pm-toolkit

Battle-tested AI skills, prompts, and workflows that make product managers 10x faster. Built for [Claude Code](https://docs.claude.com/en/docs/claude-code/overview), adaptable to any LLM.

Each sub-folder is a self-contained Claude Code plugin you can install independently.

---

## Plugins

### 🔬 [pm-deep-dive](./pm-deep-dive/)

Multi-agent PM research methodology. For **ramping into a new domain** or **pressure-testing a strategic claim** before bringing it to leadership.

Frame a falsifiable question → run parallel research agents across orthogonal angles → adversarially validate → cross-validate and synthesize → ship a post or exec brief → land findings into persistent project knowledge.

**Use it when:** investigating a claim like *"X is whitespace"*, ramping into an unfamiliar product/technical domain, building a competitive landscape, or pressure-testing a strategy hypothesis.

Commands: `/pm-deep-dive`, `/pm-dive-frame`, `/pm-dive-run`, `/pm-dive-summarize`, `/pm-dive-ship`, `/pm-dive-land`.

### 🎨 [protopilot](./protopilot/)

Turn a problem statement into a clickable, self-explainable HTML prototype — without writing code.

Four gated phases: **Frame** (Jobs-to-be-Done) → **Flow** → **Design** → **Build**. Output is a single self-contained `prototype.html` (vanilla HTML/CSS/JS, zero CDN) with an embedded "PM notes" overlay that explains the JTBD, flow, and per-screen rationale to anyone who opens the file.

**Use it when:** prototyping an idea for stakeholder review, turning a JTBD into a clickable mock, producing a shareable demo without engineering time.

Commands: `/protopilot [optional brief]`.

### 🧠 [team-knowledge](./team-knowledge/)

Build and maintain a self-validating team knowledge base. Methodology + templates only — no third-party connectors, so it works against any source stack you have.

Source artifacts → per-contributor files (with declarative compaction) → cross-validation + adversarial validation → intake queue → human-on-the-loop moderation → curated team `CLAUDE.md`. Conflict tracking is first-class; nothing reaches the curated brain without going through moderation.

**Use it when:** you want a team brain that captures decisions, blockers, and weekly signal without drift — and you want the structure to be portable across whichever chat/code/doc/task tools your team uses.

Commands: `/brain-init`, `/brain-ingest`, `/brain-evolve`, `/brain-validate`, `/brain-moderate`, `/brain-query`.

### 📚 [knowledge-portal](./knowledge-portal/)

Curated markdown knowledge base + browsable HTML portal generator. Ten opinionated topics (domain, systems, metrics, people, processes, gotchas, resources, skills, landscape, intake), with deep dives and per-subject explainers. Builds to a **single self-contained `index.html`** — zero CDN, stdlib-only Python build, works offline, attaches to email.

Pairs with `team-knowledge` — they share the same `intake.md` and `conflict_log.md` schemas so a current-state team brain and a durable knowledge base can stay in sync.

**Use it when:** you want a portable knowledge surface for onboarding, stakeholder briefings, or cross-team handoffs — without a wiki engine or auth dance.

Commands: `/portal-init`, `/portal-build`, `/portal-add-topic`, `/portal-add-explainer`.

---

## Install

Pick the plugin you want and symlink it into Claude Code's plugin directory:

```bash
cd ~/code
git clone https://github.com/tracych/ai-pm-toolkit.git

mkdir -p ~/.claude/plugins
ln -s ~/code/ai-pm-toolkit/pm-deep-dive     ~/.claude/plugins/pm-deep-dive
ln -s ~/code/ai-pm-toolkit/protopilot       ~/.claude/plugins/protopilot
ln -s ~/code/ai-pm-toolkit/team-knowledge   ~/.claude/plugins/team-knowledge
ln -s ~/code/ai-pm-toolkit/knowledge-portal ~/.claude/plugins/knowledge-portal
```

Restart Claude Code. Slash commands from each linked plugin will appear.

See each plugin's own README for detailed quickstarts and conventions.

---

## License

[MIT](./LICENSE)
