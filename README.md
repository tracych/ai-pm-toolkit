# ai-pm-toolkit

AI workflows for product managers. Built for [Claude Code](https://docs.claude.com/en/docs/claude-code/overview), adaptable to any LLM. Each sub-folder is a self-contained plugin — install only what you need.

Organized along the PM lifecycle. Within each stage the plugins compose into a workflow — pick the chain that fits your moment, ignore the rest.

---

## 💡 Ideate — sharpen what you're chasing

> Tighten the problem → adversarially kill the idea → map what AI can plausibly do → decide model vs rules.

- 🎯 **[problem-statement-doctor](./problem-statement-doctor/)** — score a draft on 8 rubrics + emit 3 rewrites at broad / focused / surgical specificity.
- ⚔️ **[idea-killer](./idea-killer/)** — 7 strongest reasons it'll fail across mandatory categories, each with a <1-week falsification test.
- 🗺️ **[model-capability-mapper](./model-capability-mapper/)** — map an idea to AI model families (LLM, vision, recsys, agents, 3D-gen, …) + capability cliffs + the "cannot do this yet" line.
- ⚖️ **[model-vs-rules-matrix](./model-vs-rules-matrix/)** — 5×3 trade-off matrix (cost, latency, explainability, maintainability, recovery × model / rules / hybrid) + rules-first MVP.

## 🧪 Validate — pressure-test before you commit

> Frame a falsifiable hypothesis → surface the assumptions that could break it → premortem the futures it could fail in → price the AI feature → enumerate how it can hallucinate.

- 🧬 **[hypothesis-canvas](./hypothesis-canvas/)** — fuzzy idea → A/B-ready hypothesis (change / metric / magnitude / segment / mechanism / abandon-if). Refuses empty abandon-if.
- 📋 **[assumption-tracker](./assumption-tracker/)** — extract every PRD assumption, plot load-bearing × testable, top-5 kill list with cheapest validation per row.
- 💀 **[premortem](./premortem/)** — 5 "this launched and failed" futures across mandatory archetypes, each with causal chain + early-warning metric. Feeds `rollback-planner`.
- 💰 **[cost-latency-budgeter](./cost-latency-budgeter/)** — live per-user-month $ + p95 latency calculator (model tier, cache %, batching, retries). Banners red when unit economics break.
- 👻 **[hallucination-profiler](./hallucination-profiler/)** — top 7 failure modes ranked by severity × likelihood, each with detection + user-facing mitigation + day-1 metric.

## 🛠️ Build — turn intent into shippable surface area

> Align engineers in the scoping room → prototype the JTBD → write the engineer-ready spec → ground the LLM behavior in a versioned prompt → design the data loop that keeps it improving → rehearse the demo.

- 🔍 **[scoping-primer](./scoping-primer/)** — drafted answers to the 12 canonical eng scoping questions w/ H/M/L confidence. L-flagged rows = your agenda.
- 🚀 **[protopilot](./protopilot/)** — JTBD-driven 4-phase HTML prototype builder (Frame → Flow → Design → Build) → single self-contained `prototype.html`.
- 📄 **[ai-feature-spec](./ai-feature-spec/)** — PM brief → engineer-ready spec across 9 mandatory sections. Refuses to render without a user job + concrete input example.
- 🪞 **[prd-to-prompt](./prd-to-prompt/)** — PRD section → versioned system prompt + extracted assertions + 5-row eval seed (1 row per assertion).
- ♻️ **[data-flywheel-designer](./data-flywheel-designer/)** — 6-stage data loop (cold-start → signal → label → store → retrain trigger → safe re-deploy) with quantified trigger + label cost.
- 🎬 **[demo-script-builder](./demo-script-builder/)** — audience-aware (exec / customer / engineer) 5-min script with labeled wow moment + 3 pre-rebutted questions + 30-sec elevator.

## ✅ Eval — measure it like a product, not a benchmark

> Curate a balanced test set from your happy-path examples → red-team it before users do.

- 🎯 **[eval-set-curator](./eval-set-curator/)** — 5 happy-path I/O pairs → balanced 50-row set across 10 canonical edge categories with machine-checkable pass criteria.
- 🛡️ **[ai-redteam-prompts](./ai-redteam-prompts/)** — 20 defensive adversarial inputs across 8 attack categories, ranked by sev × likelihood. Top-5 = fix-before-launch triage.

## 🚦 Launch & Learn — ship honestly, recover fast, get smarter

> Audit the demo→product gap → plan the rollback with numeric thresholds → fan one brief into all audience comms → retro every launch into durable team memory.

- 🚦 **[demo-to-product-gap-auditor](./demo-to-product-gap-auditor/)** — 10-dimension audit (latency, cost, eval, abuse, monitoring, fallback, trust UX, comms, on-call, retrain). Refuses "ready to ship" if 3+ dims score 1–2.
- ⏮️ **[rollback-planner](./rollback-planner/)** — 8-question intake → rollback plan w/ numeric trigger thresholds (refuses vague) + 3 audience-tuned incident comms templates.
- 📣 **[comms-pack](./comms-pack/)** — 1 brief → 6 artifacts (release notes, internal, exec, customer, social, FAQ) + tabbed HTML preview. Runs "what claim can't you defend?" pass.
- 🔁 **[retro-facilitator](./retro-facilitator/)** — fixed 5-step retro, refuses to finalize if any action item lacks owner + due date, appends to rolling local HTML archive.

## 🧠 Research & Knowledge — always-on context

> Run multi-agent deep dives → curate validated team knowledge → publish it as a portable offline portal.

- 🔬 **[pm-deep-dive](./pm-deep-dive/)** — multi-agent research pipeline: 5 composable primitives (`/pm-dive-frame` → `run` → `summarize` → `ship` → `land`).
- 🧠 **[team-knowledge](./team-knowledge/)** — self-validating team brain: artifacts → per-contributor files → cross-/adversarial-validation → intake queue → curated team `CLAUDE.md`.
- 📚 **[knowledge-portal](./knowledge-portal/)** — 10-topic curated markdown KB + stdlib-only Python builder → single self-contained `index.html` (no CDN, opens offline).

---

## Install

Clone, then symlink the plugins you want into `~/.claude/plugins/`:

```bash
cd ~/code && git clone https://github.com/tracych/ai-pm-toolkit.git
mkdir -p ~/.claude/plugins

# Install all 24 plugins:
for p in problem-statement-doctor idea-killer model-capability-mapper model-vs-rules-matrix \
         hypothesis-canvas assumption-tracker premortem cost-latency-budgeter hallucination-profiler \
         scoping-primer protopilot ai-feature-spec prd-to-prompt data-flywheel-designer demo-script-builder \
         eval-set-curator ai-redteam-prompts \
         demo-to-product-gap-auditor rollback-planner comms-pack retro-facilitator \
         pm-deep-dive team-knowledge knowledge-portal; do
  ln -sf ~/code/ai-pm-toolkit/$p ~/.claude/plugins/$p
done
```

Or pick individual ones — each plugin is fully self-contained. Restart Claude Code; slash commands appear. See each plugin's README for detailed usage.

## License

[MIT](./LICENSE)
