# data-flywheel-designer

Design the data-collection loop that makes your AI feature improve from real usage — cold-start strategy, signal capture, labeling pipeline, retraining trigger.

## What it does

Takes a one-line description of an AI feature (model type + how users interact with it) and emits a concrete flywheel design across the 6 components that actually decide whether a model gets better in production:

1. **Cold-start data plan** — where does v0 training data come from *before* a single user touches the product (synthetic, scraped, hand-curated, transfer-learning, prompted-LLM-as-baseline).
2. **Signal capture** — which user actions encode preference (explicit feedback, implicit signals like dwell / retry / edit, derived signals from downstream behavior).
3. **Labeling pipeline** — auto-label vs human-in-the-loop, who labels, queue + quality control, and **cost per label**.
4. **Storage & schema** — what gets logged per call, retention, PII strategy.
5. **Retraining trigger** — *quantified*: N samples, M weeks, K-point eval drop, or a combination.
6. **Closing the loop** — how a retrained model gets re-deployed safely: shadow-mode, A/B, gradual ramp.

For each stage you get a concrete plan **plus one thing that goes wrong if you skip it**. The skill writes a `data-flywheel.md` artifact and a single-file `flywheel.html` diagram (6 stages as a cycle with the plan inside each box) that opens with a double-click.

## Use it

In Claude Code (with this repo in your workspace):

```
/data-flywheel-designer AI code-review suggester that drops inline comments on PRs; users accept, dismiss, or rewrite each suggestion
```

Or describe your feature in conversation and let the skill auto-trigger on phrasing like "design the data loop for my AI feature", "how should we collect training data for X", "what's our flywheel for this model".

If the input doesn't name **(a) a model type or task** and **(b) the shape of user interaction**, the skill will ask for both before designing — a flywheel without an interaction shape is fiction.

## Output

Two files in your current working directory:

- **`data-flywheel.md`** — the design doc: 6 stages × {plan, failure mode if skipped, open questions}, plus a short "what to build first" sequencing note.
- **`flywheel.html`** — a single-file diagram (no CDN, no build step) showing the 6 stages as a cycle with arrows. Each stage box contains the plan text and is `contenteditable` so the PM can tweak in-browser; edits persist via `localStorage`.

## When NOT to use

- You don't have an AI feature yet — use `/ai-feature-spec` first to nail down the spec, then come back.
- You have a one-shot LLM call with no notion of "improving from usage" (e.g., a stateless format-converter) — there's no flywheel to design.
- You're designing the **eval set**, not the data-collection loop — use `/eval-set-curator`.
- You're investigating *why* the model is wrong rather than how to capture data — use `/hallucination-profiler`.

## Operating principles

- **Cold-start is the #1 thing PMs skip.** Most flywheels never spin because v0 has no data. The cold-start plan is mandatory and must name a concrete source, not "we'll figure it out."
- **Implicit signals beat explicit feedback on volume.** Explicit thumbs-up/down rates are typically under 1%. Always include at least one implicit signal (dwell, retry, edit, accept-without-modification, downstream conversion).
- **"Human-in-the-loop" without a labeling-cost-per-week estimate is not a plan, it's a hope.** The labeling row must include $/label × labels/week, or a named internal team with allocated hours.
- **The retraining trigger must be quantified.** Not "when we have enough data" but "when 1,000 new labeled samples accumulate **or** eval set win-rate drops 5pp, whichever comes first."
- **Closing the loop has a safety story.** Auto-deploying a retrained model with no shadow / no canary is how products silently regress. Every flywheel must name its re-deploy guardrail.

## Composes with

- **`/ai-feature-spec`** — the spec's telemetry section becomes the **signal-capture** row of the flywheel. Run the spec first; it tells you what events even exist.
- **`/cost-latency-budgeter`** — the labeling-cost-per-week from the flywheel feeds the cost model. If labeling is the biggest line item, you'll see it here first.
- **`/hallucination-profiler`** — failure modes from the profiler tell you which slices to *prioritize* in the labeling queue, so retraining attacks the worst regressions first.

## License

MIT. See repo root.
