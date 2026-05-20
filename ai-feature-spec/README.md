# ai-feature-spec

Turn a PM brief for an AI feature into an engineer-ready spec: model I/O contract, latency/cost budget, failure modes, eval set sketch, fallback policy.

## What it does

Takes a PM brief for an AI-powered feature (a paragraph, a doc snippet, a Slack thread) and emits a structured spec with 9 mandatory sections an engineer can actually build against:

1. **Feature description + user job** — what the feature is, in the user's words.
2. **Inputs** — exact shape: schema, examples, max sizes.
3. **Outputs** — schema, examples, format validation rules.
4. **Model contract** — model family, tier, expected p95 latency, expected cost per call.
5. **Failure modes** — top 5 ways this can go wrong (drawn from a hallucination taxonomy when relevant) with a detection signal for each.
6. **Fallback policy** — what the user actually sees when the model fails, times out, or returns garbage.
7. **Eval seed** — 5 example I/O pairs with per-row pass criteria and a one-paragraph rubric.
8. **Telemetry** — what to log per call (input hash, model version, latency, output, user action on output).
9. **Open questions** — explicit unknowns with owner placeholders, not silent gaps.

The output is one `ai-feature-spec.md` in your working directory. Hand it to an engineer, paste it into a build doc, or feed sections to `/eval-set-curator`, `/cost-latency-budgeter`, or `/prd-to-prompt`.

The tool refuses to render if the brief doesn't name the user job and provide at least one concrete input example. A spec built on vibes is worse than no spec.

## Use it

In Claude Code (with this repo in your workspace):

```
/ai-feature-spec In-product "explain this chart" button for a BI tool: user clicks a chart, gets a 2-paragraph natural-language summary
```

Or paste a longer brief into the conversation and let the skill auto-trigger on phrasing like "spec out this AI feature", "write the engineering spec for…", "what does the build doc look like for this model feature".

If your brief is missing the user job or a concrete input example, the skill will refuse and ask for both — there's no spec without them.

## Output

`ai-feature-spec.md` in your current working directory, containing all 9 sections in order:

- Feature description + user job
- Inputs (schema + examples + max sizes)
- Outputs (schema + examples + validation)
- Model contract (family, tier, p95 latency target, cost per call target)
- Failure modes (5 rows: mode, why it happens, detection signal)
- Fallback policy (what the user sees on failure, timeout, low-confidence)
- Eval seed (5 I/O rows + pass criteria + rubric paragraph)
- Telemetry (per-call log schema)
- Open questions (with `[OWNER: ?]` placeholders)

Any unknown numbers are written as `[bracketed placeholders]` and re-listed in Open questions. The skill never invents latency budgets, cost numbers, or usage estimates.

## When NOT to use

- The feature is non-AI — use a normal PRD template.
- You don't have a user-facing brief yet — use `/problem-statement-doctor` to tighten the framing first.
- You need to investigate whether the feature is worth building at all — use `/pm-deep-dive`.
- You already have a built feature and need to harden it — use `/eval-set-curator` directly to expand the eval set.

## Operating principles

- **All 9 sections are mandatory.** A spec with no fallback policy is a spec for a demo, not a product. Skip nothing.
- **Concrete examples in every I/O section.** Schemas without examples ship as bugs. Every input and output type gets at least one real example, not a `<placeholder>`.
- **Refuse to invent metrics.** If the brief lacks usage estimates, latency targets, or cost ceilings, use `[bracketed placeholders]` and flag them in Open questions. Never make up a p95 number.
- **The eval seed is 5 rows, not 50.** This is the seed, not the harness. Volume comes later via `/eval-set-curator`. Five rows is enough to stop arguments and start arguing about the right things.
- **Telemetry is per-call.** Input hash, model version, latency, output, user action on output. If you can't log all four, you can't iterate — call that out in Open questions.

## Composes with

- **`/hallucination-profiler`** — feeds the failure-modes section with a taxonomy of how the chosen model class tends to fail on this input shape.
- **`/cost-latency-budgeter`** — feeds the model contract section with realistic p95 latency and per-call cost numbers for the candidate model tier.
- **`/eval-set-curator`** — turns the 5-row eval seed into a 50-row eval set once the spec is approved.
- **`/prd-to-prompt`** — turns the input/output schema and eval seed into a tested system prompt with assertions.

## License

MIT. See repo root.
