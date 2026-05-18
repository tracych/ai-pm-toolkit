# ai-pm-toolkit

AI workflows for product managers. Built for [Claude Code](https://docs.claude.com/en/docs/claude-code/overview), adaptable to any LLM. Each sub-folder is a self-contained plugin you can install independently.

## Plugins

### 🔬 [pm-deep-dive](./pm-deep-dive/)
- **What:** multi-agent research pipeline — frame a falsifiable claim, spawn parallel agents across orthogonal angles, adversarially validate, cross-validate, ship.
- **When:** ramping into a new domain, pressure-testing a strategic claim ("X is whitespace"), building a competitive landscape, prepping a leadership review.
- **How:** `/pm-deep-dive` (or the 5 primitives: `/pm-dive-frame`, `/pm-dive-run`, `/pm-dive-summarize`, `/pm-dive-ship`, `/pm-dive-land`).

### 🎨 [protopilot](./protopilot/)
- **What:** JTBD-driven HTML prototype builder. Four gated phases (Frame → Flow → Design → Build) produce a single self-contained `prototype.html` with embedded "PM notes" that explain the rationale.
- **When:** prototyping for stakeholder review, turning a JTBD into a clickable mock, producing a shareable demo without engineering time.
- **How:** `/protopilot [optional brief]`.

### 🧠 [team-knowledge](./team-knowledge/)
- **What:** self-validating team brain. Source artifacts → per-contributor files → cross-validation + adversarial validation → intake queue → human-on-the-loop moderation → curated team `CLAUDE.md`. Templates only — no third-party connectors, so it works against any source stack.
- **When:** you want a team brain that captures decisions, blockers, and weekly signal without drift — portable across your chat/code/doc/task tools.
- **How:** `/brain-init`, `/brain-ingest`, `/brain-evolve`, `/brain-validate`, `/brain-moderate`, `/brain-query`.

### 📚 [knowledge-portal](./knowledge-portal/)
- **What:** curated markdown KB (10 opinionated topics) + stdlib-only Python builder that renders to a single self-contained `index.html` — zero CDN, opens offline, attaches to email. Pairs with `team-knowledge` via a shared intake/conflict schema.
- **When:** onboarding new teammates, stakeholder briefings, cross-team handoffs — without a wiki engine or auth dance.
- **How:** `/portal-init`, `/portal-build`, `/portal-add-topic`, `/portal-add-explainer`.

## Install

Clone the repo, then symlink the plugins you want into `~/.claude/plugins/`:

```bash
cd ~/code && git clone https://github.com/tracych/ai-pm-toolkit.git

mkdir -p ~/.claude/plugins
ln -s ~/code/ai-pm-toolkit/pm-deep-dive     ~/.claude/plugins/pm-deep-dive
ln -s ~/code/ai-pm-toolkit/protopilot       ~/.claude/plugins/protopilot
ln -s ~/code/ai-pm-toolkit/team-knowledge   ~/.claude/plugins/team-knowledge
ln -s ~/code/ai-pm-toolkit/knowledge-portal ~/.claude/plugins/knowledge-portal
```

Restart Claude Code. Each plugin's slash commands will appear. See each plugin's own README for detailed usage.

## License

[MIT](./LICENSE)
