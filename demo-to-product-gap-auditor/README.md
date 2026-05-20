# demo-to-product-gap-auditor

Given a working AI demo, audit the gap to a shippable product across 10 dimensions: latency-at-scale, cost-at-scale, eval coverage, abuse defense, monitoring, fallback, UX trust signals, comms readiness, on-call story, retrain story. Triages must-fix vs ship-with-known-gap.

## What it does

You have a working AI demo. Maybe it's a Notion-doc prototype, maybe it's a Friday-afternoon hack, maybe it's a polished internal tool the team is itching to ship. This skill walks 10 audit dimensions and for each:

1. **Scores readiness 1–5** (1 = "demo-only, will blow up in week 1", 5 = "ship-ready") with a one-sentence rationale tied to what you described.
2. **Names the single biggest concrete gap** in plain language — not a category, the actual thing that will break.
3. **Proposes the minimum fix** to get to a 4 (ship-ready-with-acceptable-risk). Not the gold-plated version. The cheapest defensible one.

Then it triages the dimensions into **must-fix-before-launch** (anything still at 1–2) and **ship-with-known-gap** (3s with an owner and a fallback). If 3 or more dimensions score 1–2, the tool **refuses to render "ready to ship" framing** and emits a "this is still a demo" report instead.

Output lives in `demo-to-product-audit/<slug>/`:

- `audit.html` — single-file interactive checklist (no CDN, localStorage save, JSON export, ship-readiness banner).
- `audit.md` — executive summary naming the 3 must-fix items.
- `audit.json` — machine-readable scorecard for piping into other tools.

## Use it

In Claude Code (with this repo in your workspace):

```
/demo-to-product-gap-auditor AI assistant for sales reps that drafts cold-outreach emails — currently a Notion-doc demo using GPT-4o, planning to ship to 200 reps in 4 weeks
```

Or describe the demo in conversation and let the skill auto-trigger on phrasing like "audit my AI demo", "is this ready to ship?", "what's the gap between demo and product?".

The skill will ask for: (1) what the demo does, (2) what model + infra it uses, (3) current state of the implementation, (4) target launch surface + audience size. If those aren't in the input it will ask before scoring.

## Output

`demo-to-product-audit/<slug>/audit.html` — open in a browser. Each dimension has a score slider, the named gap, the proposed minimum fix, a "we'll fix this" checkbox, and a free-text owner field. State persists via localStorage. A banner at the top reads **READY** (green, 0 dimensions at 1–2), **SHIP WITH KNOWN GAPS** (yellow, 1–2 dimensions at 1–2 with named owners), or **STILL A DEMO** (red, 3+ dimensions at 1–2).

`demo-to-product-audit/<slug>/audit.md` — executive summary. The top of the doc is the 3 must-fix items, named and owned. Below that is the full scorecard table. Below that is what to say in launch comms if you ship with the known gaps.

`demo-to-product-audit/<slug>/audit.json` — `{dimension, score, gap, fix, owner, status}[]` plus a top-level `verdict`.

## When NOT to use

- You don't have a working demo yet — use `protopilot` to build the prototype first, then audit it.
- You're scoping a feature that doesn't exist — use `ai-feature-spec` or `prd-to-prompt`.
- You want a post-launch retro — use `retro-facilitator`. This skill is pre-launch only.
- You already have a launch checklist your org uses — use that. This skill is the default checklist for teams that don't have one.

## Operating principles

- **Score honestly.** Most AI demos score 1–2 on 4+ dimensions. The audit is useful only if it reflects that. The skill will not soft-pedal scores to make you feel good about Friday's launch.
- **"Acceptable risk" is the ship bar, not "perfect."** A 4/5 with a documented gap and an owner is shippable. A 1/5 with a TODO is not. The minimum fix is calibrated to 4, not 5.
- **Monitoring + on-call are mandatory dimensions.** Most AI features ship with no on-call rotation and the founding PM becomes oncall by default at 2am. The audit surfaces this even when the team would rather not look.
- **Fallback policy is a dimension** because a demo with no fallback is a demo, not a product. Even "show the user a static error message" counts as a fallback — but only if it's explicitly designed, not implicit.
- **Comms readiness includes "what we say when the model is wrong."** If launch comms have no failure narrative, score it 2. "We'll figure it out if it happens" is not a comms plan.

## Composes with

- **`/cost-latency-budgeter`** — feed it the cost-at-scale and latency-at-scale dimensions to turn the qualitative scores into hard budget numbers.
- **`/hallucination-profiler`** — sharpens the eval coverage + UX trust signal dimensions with concrete failure-mode tests.
- **`/ai-redteam-prompts`** — generates the test corpus for the abuse defense dimension.
- **`/rollback-planner`** — turns the monitoring + on-call dimensions into a concrete kill-switch + rotation plan.
- **`/comms-pack`** — drafts the launch comms (with failure narrative) that the comms readiness dimension demands.

## License

MIT. See repo root.
