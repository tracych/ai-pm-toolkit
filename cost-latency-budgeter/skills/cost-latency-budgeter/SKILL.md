---
name: cost-latency-budgeter
description: |
  Modeling skill that builds a back-of-envelope per-user-month cost and p95 latency estimate for a proposed AI feature, then emits an interactive single-file HTML calculator with sliders for model tier (frontier / mid / small / open), prompt cache hit %, output length, batching factor, and retries. Also writes a markdown summary with a baseline scenario plus three sensitivities (worst-case usage spike, model price drop 50%, cache hit reaches 80%) and a machine-readable JSON. Use when the user wants to: size the unit economics of an AI feature before committing to build, pressure-test whether the feature can clear its LTV contribution, find which knob (cache, batching, model tier) actually moves the cost curve, or estimate p95 latency across the full pipeline (retrieval + model + network + retries), not just the model call.

  Do NOT trigger for: features that already have production telemetry (use real numbers), model selection from scratch (use model-capability-mapper first), non-LLM infra cost modeling (DB, storage, egress), or CFO-grade financial models with amortization and GPU reservations. Refuse if the user has not supplied at minimum: DAU estimate, calls per user per day, and rough input/output token sizes.
---

# cost-latency-budgeter (skill)

Build a back-of-envelope cost and latency model for an AI feature. Make every number traceable. Hand the PM a tunable calculator, not a static spreadsheet.

## Operating principles

- **Show the math.** Every number in the markdown and JSON traces back to inputs the PM provided. No hidden constants — model prices and latencies come from `assets/model_tiers.md`, which is explicitly labeled "verify before quoting."
- **Default cost numbers are conservative ranges, not point estimates.** Use the upper end of the range as the "plan against" number in the markdown. Show the full range in the HTML.
- **Sliders matter more than the baseline.** The HTML calculator is the primary artifact. The markdown is the snapshot a PM pastes in a doc. Do not skip the HTML.
- **Surface the cliff.** If per-user-month cost exceeds the configurable threshold (default `$1`), banner the HTML red and call it out in the markdown.
- **Latency is additive across the pipeline.** p95 = retrieval + model first-token + model generation + network + (retry probability × retry latency). Bare model latency lies.

## Inputs

Required from the user (refuse if any are missing):

1. **DAU** — daily active users who will hit this feature.
2. **Calls per user per day** — average invocations per active user.
3. **Average input tokens per call** — rough order of magnitude is fine (300, 3000, 30000).
4. **Average output tokens per call** — same.

Optional (sensible defaults if absent):

- Model tier (`frontier` / `mid` / `small` / `open`) — default `mid`.
- Expected prompt cache hit % — default `0`.
- Batching factor (calls collapsed into one request) — default `1`.
- Retry rate — default `5%`.
- LTV / cost threshold for the red banner — default `$1` per user per month.

If any required input is missing, respond with a single ask listing exactly what's missing. Do not invent numbers.

## Step 1 — Load the model tier reference

Read `assets/model_tiers.md` (relative to this skill). It lists 4 tiers with cost ranges ($/M input tokens, $/M output tokens) and latency ranges (first-token ms, tokens/sec). Use those ranges — do not invent prices. The file is dated and labeled "verify before quoting"; if the user wants exact billing, tell them to confirm against the provider's pricing page.

## Step 2 — Build a slug and target directory

Slug the feature description (lowercase, dashes, max 40 chars). Create `cost-latency-budgeter/budgets/<slug>/`.

## Step 3 — Compute the baseline

For the user's selected tier, compute (using the upper end of the cost range as the plan-against number, the midpoint of the latency range as the p50 and the upper end as p95):

```
effective_input_tokens  = input_tokens × (1 - cache_hit_rate)
per_call_cost           = (effective_input_tokens / 1e6) × input_price_upper
                        + (output_tokens          / 1e6) × output_price_upper
per_user_day_cost       = per_call_cost × calls_per_user_per_day / batching_factor
per_user_month_cost     = per_user_day_cost × 30
monthly_total_at_N      = per_user_month_cost × N  (for N in {10_000, 100_000, 1_000_000})

p95_latency_ms = retrieval_ms             # default 50 if RAG-ish, 0 otherwise
               + first_token_ms_upper
               + (output_tokens / tokens_per_sec_lower) × 1000
               + network_ms                # default 100
               + retry_rate × retry_penalty_ms   # retry_penalty ~= base latency
```

Be explicit in `budget.md` about every constant used.

## Step 4 — Compute three sensitivity scenarios

1. **Worst-case usage spike** — multiply `calls_per_user_per_day` by 3. Recompute per-user-month and monthly totals.
2. **Model price drop 50%** — halve both input and output prices for the selected tier. Recompute.
3. **Cache hit reaches 80%** — set `cache_hit_rate = 0.80`. Recompute.

Each scenario gets a one-line "what this tells the PM" interpretation.

## Step 5 — Emit `budget.json`

Write inputs and all computed outputs as JSON. Schema:

```json
{
  "feature": "<verbatim user description>",
  "slug": "<slug>",
  "generated_at": "<ISO-8601 date>",
  "inputs": {
    "dau": 100000,
    "calls_per_user_per_day": 5,
    "input_tokens": 3000,
    "output_tokens": 300,
    "model_tier": "mid",
    "cache_hit_rate": 0.0,
    "batching_factor": 1,
    "retry_rate": 0.05,
    "threshold_per_user_month_usd": 1.0
  },
  "baseline": {
    "per_call_cost_usd": 0.0,
    "per_user_month_usd": 0.0,
    "monthly_total_usd": {"10k": 0.0, "100k": 0.0, "1m": 0.0},
    "p95_latency_ms": 0
  },
  "sensitivities": {
    "usage_spike_3x":    { "per_user_month_usd": 0.0, "monthly_total_100k_usd": 0.0 },
    "model_price_-50":   { "per_user_month_usd": 0.0, "monthly_total_100k_usd": 0.0 },
    "cache_hit_80":      { "per_user_month_usd": 0.0, "monthly_total_100k_usd": 0.0 }
  },
  "model_tier_reference": "assets/model_tiers.md (verify before quoting)"
}
```

## Step 6 — Emit `budget.md`

Structure:

```
# Cost & Latency Budget — <feature one-liner>

> Numbers are back-of-envelope. Verify model prices against the provider's pricing page before quoting these in a launch review.

## Inputs
- DAU: ...
- Calls/user/day: ...
- Input tokens: ...
- Output tokens: ...
- Model tier: ...
- Cache hit %: ...
- Batching factor: ...
- Retry rate: ...

## Baseline
| Metric | Value |
|---|---|
| Per-call cost | $... |
| Per-user-month | $... |
| Monthly @ 10K | $... |
| Monthly @ 100K | $... |
| Monthly @ 1M | $... |
| p95 latency | ... ms |

**Math (per-call):** `(input_tokens × (1 - cache_hit) / 1M) × $input_price + (output_tokens / 1M) × $output_price`

**Latency stack:** retrieval ... ms + first-token ... ms + generation ... ms + network ... ms + retry penalty ... ms

<RED BANNER if per_user_month > threshold>
> ⚠️  Per-user-month cost ($X.XX) exceeds the configured threshold ($1.00). If this feature's plausible LTV contribution is under $X.XX/user/month, the unit economics do not clear. Tune the sliders in `budget.html` before committing.

## Sensitivities

### 1. Worst-case usage spike (3× calls/user/day)
- Per-user-month: $...
- Monthly @ 100K: $...
- *What this tells you:* ...

### 2. Model price drop 50%
- Per-user-month: $...
- Monthly @ 100K: $...
- *What this tells you:* ...

### 3. Cache hit reaches 80%
- Per-user-month: $...
- Monthly @ 100K: $...
- *What this tells you:* ...

## The knob that moves the curve
<one-paragraph summary: which sensitivity moved the per-user-month number the most, and what the PM should do about it>

## Open the interactive calculator
`budget.html` in this folder — double-click. Sliders update live; localStorage saves your scenario; "Export JSON" hands the state to teammates.
```

## Step 7 — Emit `budget.html`

Copy `assets/budget_template.html` into the budget folder. Then inject the user's baseline inputs as initial values by replacing the template's `__INITIAL_INPUTS__` JSON placeholder. Do not modify the calculator logic; the template is self-contained, no CDN, opens with double-click.

## Step 8 — Report back

After writing, report:

1. Absolute path to the budget folder.
2. Per-user-month cost (baseline) and whether it tripped the red banner.
3. Which of the three sensitivities moved the number the most.
4. Suggested next workflow (e.g., "feed the cache-hit number into `/hypothesis-canvas` as the abandon-if metric").

## Output format spec

- `budget.html` — single file, no CDN, opens with double-click. Sliders for model tier, cache hit %, batching, retries. Number inputs for DAU, calls/user/day, input tokens, output tokens. Live-updates per-call cost, per-user-month, monthly @ 10K/100K/1M, p95 latency. localStorage save + JSON export. Red banner when per-user-month > threshold.
- `budget.md` — markdown, structure above.
- `budget.json` — machine-readable, schema above.

## How this differs from adjacent skills

- **`/model-capability-mapper`** — picks the model family. cost-latency-budgeter assumes the family is already chosen (or uses `mid` as default) and sizes the economics.
- **`/hypothesis-canvas`** — captures the test design. cost-latency-budgeter feeds it the threshold knob ("if cache hit < X, abandon").
- **`/demo-to-product-gap-auditor`** — post-launch comparison. cost-latency-budgeter is the pre-launch projection that auditor checks against.
- **Generic "how much will this cost" prompts** — produce a single point estimate with hidden assumptions. This skill enforces ranges, a pipeline-aware latency model, and a tunable HTML artifact so the PM can find the knob themselves.
