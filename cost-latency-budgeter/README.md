# cost-latency-budgeter

Back-of-envelope per-user-month cost and p95 latency model for a proposed AI feature, with knobs (model tier, caching, batching) you can tune live.

## What it does

Takes a PM's rough description of an AI feature — DAU, calls per user per day, average input/output token sizes, model family — and builds a back-of-envelope cost and latency model you can poke at:

1. **Computes a baseline:** per-call cost, per-user-month cost, total monthly cost at 10K / 100K / 1M users, and a p95 latency estimate that sums across pipeline stages (retrieval + model + network + retries), not just the model call.
2. **Generates an interactive HTML calculator** with sliders for model tier (frontier / mid / small / open), prompt cache hit %, output length, batching factor, and retries. Numbers update live as you drag.
3. **Writes 3 sensitivity scenarios** alongside the baseline: worst-case usage spike, model price drop of 50%, cache hit reaching 80%. So you know which knob actually moves the economics.

If per-user-month cost exceeds a configurable threshold (default `$1`), the HTML banners it red — that's the cliff PMs need to see before promising the feature.

## Use it

In Claude Code (with this repo in your workspace):

```
/cost-latency-budgeter AI summarization on email threads, 100K DAU, 5 calls/user/day, ~3000 input tokens, ~300 output tokens, mid-tier model
```

Or describe the feature in conversation and let the skill auto-trigger on phrasing like "what will this cost", "model the unit economics", "is this AI feature affordable", "p95 latency for this pipeline".

If the input is missing any of DAU, calls/user/day, or rough token sizes, the skill refuses and lists what's missing — no fabricated baselines.

## Output

Written to `cost-latency-budgeter/budgets/<slug>/`:

- **`budget.html`** — single-file interactive calculator, no CDN, opens with double-click. Sliders, live math, localStorage save, JSON export.
- **`budget.md`** — baseline scenario + 3 sensitivity scenarios in plain markdown so it can paste into a doc or Slack.
- **`budget.json`** — machine-readable inputs and computed outputs, suitable for piping into another workflow.

## When NOT to use

- You already have production telemetry — use real numbers, not back-of-envelope.
- You haven't picked a model family yet — use `/model-capability-mapper` first.
- You're modeling infra/compute costs unrelated to LLM inference (DB, storage, egress) — this tool only covers the LLM call path.
- You need a CFO-grade financial model with amortization, GPU reservations, etc. — this is a PM thinking tool, not a finance artifact.

## Operating principles

- **Show the math.** Every number in `budget.md` traces back to inputs the PM provided. No hidden assumptions, no smuggled-in constants.
- **Default cost numbers are conservative ranges, not point estimates.** PMs over-trust point estimates. The HTML shows a range; the markdown reports the upper end of the range as the "plan against" number.
- **Sliders matter more than the baseline.** The PM's real job isn't reading the baseline — it's finding the knob (cache hit %, model tier, output length cap) that makes economics work.
- **Surface the cliff.** If per-user-month cost exceeds the feature's plausible LTV contribution, the HTML banners it red. Don't let a PM walk into a launch review with $4/user/month math hidden in a spreadsheet.
- **Latency is additive across the pipeline.** p95 estimate sums retrieval + model first-token + model generation + network + retries. Bare model latency lies; pipeline latency doesn't.

## Composes with

- **`/model-capability-mapper`** — pick the model family first, then size its cost and latency here.
- **`/hypothesis-canvas`** — the cost knob (e.g., "cache hit > 60%") often becomes the abandon-if metric in the canvas.
- **`/demo-to-product-gap-auditor`** — after launch, verify production economics match what this tool projected.

## License

MIT. See repo root.
