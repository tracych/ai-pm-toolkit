# ai-pm-toolkit

AI workflows for product managers. Built for [Claude Code](https://docs.claude.com/en/docs/claude-code/overview), adaptable to any LLM. Each sub-folder is a self-contained plugin you can install independently.

The toolkit is organized around the PM lifecycle. Most PMs reach for a handful, not all.

## Ideate

Tools for sharpening a problem before you commit to building.

### [problem-statement-doctor](./problem-statement-doctor/)
Score a draft problem statement on 8 rubrics (specificity, user-centricity, measurability, falsifiability, scope, urgency, evidence, success criteria) and emit 3 rewrites at broad / focused / surgical specificity. Run it before `pm-deep-dive` or `protopilot` for a cleaner seed.

### [idea-killer](./idea-killer/)
Adversarial steel-man-the-no. Generates the 7 strongest reasons an idea will fail across mandatory categories (demand, distribution, competition, regulation, unit economics, organization, timing), ranked by likelihood x consequence, with the cheapest <1-week falsification test per failure mode. Structural sycophancy counter.

## Build & Validate

Tools for stating what you believe, pressure-testing it, and pairing with engineers.

### [hypothesis-canvas](./hypothesis-canvas/)
Convert a fuzzy idea into a falsifiable A/B-ready hypothesis with 6 mandatory fields (change / metric / magnitude / segment / mechanism / abandon-if). Hard refusal if abandon-if is empty. Self-contained HTML canvas with JSON export.

### [assumption-tracker](./assumption-tracker/)
Extract every assumption from a PRD, plot on a load-bearing x testable 2x2, emit a top-5 kill list with the cheapest validation experiment per assumption. Interactive single-file HTML.

### [premortem](./premortem/)
Simulate 5 distinct "this launched and failed" futures across mandatory archetypes (adoption-flop, trust-incident, abuse-vector, performance-regression, internal-politics), each with a causal chain and an instrumentable early-warning metric. Feeds directly into `rollback-planner` thresholds.

### [scoping-primer](./scoping-primer/)
Pre-meeting briefing of the 12 canonical engineering scoping questions (data shape, scale, latency, failure modes, auth, storage, migration, observability, rollback, dependencies, edge cases, success metric), each with a drafted answer + H/M/L confidence + owner placeholder for the unknowns. The L-flagged rows become your meeting agenda.

### [protopilot](./protopilot/)
JTBD-driven HTML prototype builder. Four gated phases (Frame → Flow → Design → Build) produce a single self-contained `prototype.html` with embedded PM notes explaining the rationale.

### [demo-script-builder](./demo-script-builder/)
Audience-aware 5-minute demo script (`exec` | `customer` | `engineer`) with stage directions, a labeled wow moment, and 3 pre-rebutted likely audience questions. 30-second elevator version at top.

## Launch & Learn

Tools for shipping, monitoring, and learning from real launches.

### [rollback-planner](./rollback-planner/)
Eight-question intake (change / blast radius / kill-switch / owners / dependencies / metric thresholds / comms surfaces / dry-run cadence) produces a rollback plan with numeric trigger thresholds (it refuses vague ones), 3 audience-tuned incident comms templates, and a self-contained HTML checklist with localStorage state.

### [comms-pack](./comms-pack/)
Fans one launch brief into 6 audience-tuned artifacts (release notes, internal announcement, exec update, customer email, social post, FAQ) plus a single-file HTML preview that tabs across them. Runs a "what claim here can't you defend?" pass on the exec + customer versions.

### [retro-facilitator](./retro-facilitator/)
Walks a fixed 5-step post-launch retro (what shipped / what worked / what surprised / what we'd do differently / action items), refuses to finalize if any action item lacks owner + due date, and appends a row to a rolling local HTML archive — the substrate for cross-launch pattern matching later.

## Research & Knowledge

Always-on tools for building durable context.

### [pm-deep-dive](./pm-deep-dive/)
Multi-agent research pipeline — frame a falsifiable claim, spawn parallel agents across orthogonal angles, adversarially validate, cross-validate, ship as a post or exec brief, land findings into project knowledge. Five composable primitives: `/pm-dive-frame`, `/pm-dive-run`, `/pm-dive-summarize`, `/pm-dive-ship`, `/pm-dive-land`.

### [team-knowledge](./team-knowledge/)
Self-validating team brain. Source artifacts → per-contributor files → cross-validation + adversarial validation → intake queue → human-on-the-loop moderation → curated team `CLAUDE.md`. Templates only — works against any source stack.

### [knowledge-portal](./knowledge-portal/)
Curated markdown KB (10 opinionated topics) + stdlib-only Python builder that renders to a single self-contained `index.html` — zero CDN, opens offline, attaches to email. Pairs with `team-knowledge` via a shared intake/conflict schema.

## Install

Clone the repo, then symlink the plugins you want into `~/.claude/plugins/`:

```bash
cd ~/code && git clone https://github.com/tracych/ai-pm-toolkit.git
mkdir -p ~/.claude/plugins

# Pick what you want — each plugin is independent
ln -s ~/code/ai-pm-toolkit/problem-statement-doctor ~/.claude/plugins/problem-statement-doctor
ln -s ~/code/ai-pm-toolkit/idea-killer              ~/.claude/plugins/idea-killer
ln -s ~/code/ai-pm-toolkit/hypothesis-canvas        ~/.claude/plugins/hypothesis-canvas
ln -s ~/code/ai-pm-toolkit/assumption-tracker       ~/.claude/plugins/assumption-tracker
ln -s ~/code/ai-pm-toolkit/premortem                ~/.claude/plugins/premortem
ln -s ~/code/ai-pm-toolkit/scoping-primer           ~/.claude/plugins/scoping-primer
ln -s ~/code/ai-pm-toolkit/protopilot               ~/.claude/plugins/protopilot
ln -s ~/code/ai-pm-toolkit/demo-script-builder      ~/.claude/plugins/demo-script-builder
ln -s ~/code/ai-pm-toolkit/rollback-planner         ~/.claude/plugins/rollback-planner
ln -s ~/code/ai-pm-toolkit/comms-pack               ~/.claude/plugins/comms-pack
ln -s ~/code/ai-pm-toolkit/retro-facilitator        ~/.claude/plugins/retro-facilitator
ln -s ~/code/ai-pm-toolkit/pm-deep-dive             ~/.claude/plugins/pm-deep-dive
ln -s ~/code/ai-pm-toolkit/team-knowledge           ~/.claude/plugins/team-knowledge
ln -s ~/code/ai-pm-toolkit/knowledge-portal         ~/.claude/plugins/knowledge-portal
```

Restart Claude Code. Each plugin's slash commands appear. See each plugin's README for detailed usage.

## License

[MIT](./LICENSE)
