# ai-pm-toolkit

AI workflows for product managers. Built for [Claude Code](https://docs.claude.com/en/docs/claude-code/overview), adaptable to any LLM. Each sub-folder is a self-contained plugin you can install independently.

The toolkit is organized around the PM lifecycle. Most PMs reach for a handful, not all.

## Ideate

Tools for sharpening a problem before you commit to building.

### [problem-statement-doctor](./problem-statement-doctor/)
Score a draft problem statement on 8 rubrics (specificity, user-centricity, measurability, falsifiability, scope, urgency, evidence, success criteria) and emit 3 rewrites at broad / focused / surgical specificity. Run it before `pm-deep-dive` or `protopilot` for a cleaner seed.

### [idea-killer](./idea-killer/)
Adversarial steel-man-the-no. Generates the 7 strongest reasons an idea will fail across mandatory categories (demand, distribution, competition, regulation, unit economics, organization, timing), ranked by likelihood x consequence, with the cheapest <1-week falsification test per failure mode. Structural sycophancy counter.

### [model-capability-mapper](./model-capability-mapper/)
Given a product idea, maps which AI model families (LLM-frontier, vision-LLM, recsys, world-models, 3D-generative, agents, embeddings, classical-ML, etc.) plausibly enable it, where the capability cliffs are, and what "cannot do this yet" boundaries you'll hit. Recommends one primary family + one fallback + the cheapest <1-week experiment that resolves the biggest cliff.

### [model-vs-rules-matrix](./model-vs-rules-matrix/)
For a proposed AI feature, forces a 5×3 trade-off matrix (cost-at-scale, p95-latency, explainability, maintainability, failure-recovery × pure-model / pure-rules / hybrid). Emits a scored recommendation, two "switch-your-answer-if" triggers, and the rules-first MVP version you could ship before adding the model.

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

### [cost-latency-budgeter](./cost-latency-budgeter/)
Back-of-envelope per-user-month cost and p95 latency model for a proposed AI feature, with live sliders for model tier, cache hit %, batching, retries. Single-file HTML calculator (no CDN, localStorage) + markdown baseline + 3 sensitivity scenarios. Banners red when per-user economics break.

### [hallucination-profiler](./hallucination-profiler/)
For an LLM feature, enumerates the top 7 hallucination/failure modes (from a canonical taxonomy of 12) tied to your specific input/output shape, ranked by severity × likelihood. Each gets a detection strategy AND a user-facing mitigation. Outputs the 3 day-1 metrics to instrument.

### [ai-feature-spec](./ai-feature-spec/)
Turns a PM brief into an engineer-ready spec across 9 mandatory sections (inputs, outputs, model contract, failure modes, fallback policy, eval seed, telemetry, open questions). Refuses to render if the brief lacks a user job or concrete input example.

### [prd-to-prompt](./prd-to-prompt/)
Turns a PRD section describing LLM behavior into a versioned system prompt (role / capabilities / constraints / refusal policy / output format / examples) + extracted testable assertions + a 5-row eval seed where every assertion has a row that would catch its violation.

### [data-flywheel-designer](./data-flywheel-designer/)
Designs the 6-stage data-collection loop that lets your AI feature improve from real usage (cold-start, signal capture, labeling pipeline, storage, retraining trigger, safe re-deploy). Forces a quantified retraining trigger and a labeling cost estimate. Editable single-file HTML diagram.

### [eval-set-curator](./eval-set-curator/)
Expands 5 happy-path example I/O pairs into a balanced 50-row eval set covering 10 canonical edge-case categories (empty, hostile, multilingual, ambiguous, format-violating, out-of-scope, etc.) with concrete expected behavior + machine-checkable pass criteria. JSONL + single-file HTML viewer.

### [ai-redteam-prompts](./ai-redteam-prompts/)
Generates 20 defensive adversarial test inputs across 8 attack categories (prompt injection direct & indirect, jailbreak, PII extraction, bias probes, toxic induction, harmful-action-as-tool, format-violation) ranked by severity × likelihood. Top-5 become the fix-before-launch triage list. Severity is anchored to blast radius.

## Launch & Learn

Tools for shipping, monitoring, and learning from real launches.

### [rollback-planner](./rollback-planner/)
Eight-question intake (change / blast radius / kill-switch / owners / dependencies / metric thresholds / comms surfaces / dry-run cadence) produces a rollback plan with numeric trigger thresholds (it refuses vague ones), 3 audience-tuned incident comms templates, and a self-contained HTML checklist with localStorage state.

### [comms-pack](./comms-pack/)
Fans one launch brief into 6 audience-tuned artifacts (release notes, internal announcement, exec update, customer email, social post, FAQ) plus a single-file HTML preview that tabs across them. Runs a "what claim here can't you defend?" pass on the exec + customer versions.

### [retro-facilitator](./retro-facilitator/)
Walks a fixed 5-step post-launch retro (what shipped / what worked / what surprised / what we'd do differently / action items), refuses to finalize if any action item lacks owner + due date, and appends a row to a rolling local HTML archive — the substrate for cross-launch pattern matching later.

### [demo-to-product-gap-auditor](./demo-to-product-gap-auditor/)
Given a working AI demo, audits the gap to a shippable product across 10 dimensions (latency-at-scale, cost-at-scale, eval coverage, abuse defense, monitoring, fallback, UX trust signals, comms readiness, on-call story, retrain story). Refuses to render "ready to ship" framing if 3+ dimensions score 1-2. Outputs an interactive single-file checklist + an exec summary naming the 3 must-fix items.

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

# Building AI-model-powered products (LLM / vision / recsys / agents / 3D-gen / world-models)
ln -s ~/code/ai-pm-toolkit/model-capability-mapper    ~/.claude/plugins/model-capability-mapper
ln -s ~/code/ai-pm-toolkit/model-vs-rules-matrix      ~/.claude/plugins/model-vs-rules-matrix
ln -s ~/code/ai-pm-toolkit/cost-latency-budgeter      ~/.claude/plugins/cost-latency-budgeter
ln -s ~/code/ai-pm-toolkit/hallucination-profiler     ~/.claude/plugins/hallucination-profiler
ln -s ~/code/ai-pm-toolkit/ai-feature-spec            ~/.claude/plugins/ai-feature-spec
ln -s ~/code/ai-pm-toolkit/prd-to-prompt              ~/.claude/plugins/prd-to-prompt
ln -s ~/code/ai-pm-toolkit/data-flywheel-designer     ~/.claude/plugins/data-flywheel-designer
ln -s ~/code/ai-pm-toolkit/eval-set-curator           ~/.claude/plugins/eval-set-curator
ln -s ~/code/ai-pm-toolkit/ai-redteam-prompts         ~/.claude/plugins/ai-redteam-prompts
ln -s ~/code/ai-pm-toolkit/demo-to-product-gap-auditor ~/.claude/plugins/demo-to-product-gap-auditor
```

Restart Claude Code. Each plugin's slash commands appear. See each plugin's README for detailed usage.

## Building AI-model-powered products

The original toolkit is mostly model-agnostic PM workflow. These ten plugins specifically target the gap between "we have a demo with a powerful model" and "we have a product real users can rely on." They compose along the 0→1 lifecycle:

- **Ideate** — pick what the model can plausibly do: [`/model-capability-mapper`](./model-capability-mapper/), [`/model-vs-rules-matrix`](./model-vs-rules-matrix/)
- **Validate** — pressure-test the economics and failure surface: [`/cost-latency-budgeter`](./cost-latency-budgeter/), [`/hallucination-profiler`](./hallucination-profiler/)
- **Build** — translate intent into shippable engineering surface area: [`/ai-feature-spec`](./ai-feature-spec/), [`/prd-to-prompt`](./prd-to-prompt/), [`/data-flywheel-designer`](./data-flywheel-designer/)
- **Eval** — measure the AI feature like a product, not a benchmark: [`/eval-set-curator`](./eval-set-curator/), [`/ai-redteam-prompts`](./ai-redteam-prompts/)
- **Launch & Learn** — close the demo→product gap honestly: [`/demo-to-product-gap-auditor`](./demo-to-product-gap-auditor/)

They compose: capability-mapper picks the model family → cost-latency-budgeter prices it → ai-feature-spec turns it into a contract → prd-to-prompt grounds the contract in tested behavior → hallucination-profiler enumerates the failure surface → eval-set-curator and ai-redteam-prompts turn that surface into a test set → data-flywheel-designer wires in the loop that keeps improving v0 after launch → demo-to-product-gap-auditor refuses to call it shipped until 7+ dimensions are at a 4.

## License

[MIT](./LICENSE)
