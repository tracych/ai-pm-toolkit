# Cost & Latency Budget — AI summarization on email threads

> Numbers are back-of-envelope. Verify model prices against the provider's pricing page before quoting these in a launch review.

## Inputs
- DAU: 100,000
- Calls/user/day: 5
- Input tokens: 3,000
- Output tokens: 300
- Model tier: mid
- Cache hit %: 0
- Batching factor: 1
- Retry rate: 5%

## Baseline (plan-against numbers, using upper end of tier cost range)

| Metric | Value |
|---|---|
| Per-call cost | $0.0135 |
| Per-user-day cost | $0.0675 |
| Per-user-month cost | $2.025 |
| Monthly @ 10K users | $20,250 |
| Monthly @ 100K users | $202,500 |
| Monthly @ 1M users | $2,025,000 |
| p95 latency | ~3,100 ms |

**Math (per-call):**
`(3000 × (1 - 0) / 1M) × $3 + (300 / 1M) × $15 = $0.009 + $0.0045 = $0.0135`

**Latency stack (p95):**
`0 ms retrieval + 800 ms first-token + (300 / 60 tps) × 1000 = 5000 ms generation + 100 ms network + 0.05 × 3000 ms retry penalty = ~6050 ms`

(The example uses a more realistic tokens/sec of 100 for "mid" tier, giving ~3,100 ms; the upper end of the latency stack is shown above. The HTML calculator lets you sweep this.)

> ⚠️  **Per-user-month cost ($2.03) exceeds the configured threshold ($1.00).**
> At 100K DAU this feature costs ~$202K/month. If summarized-thread engagement does not plausibly drive >$2/user/month in retained ARPU, monetized upsell, or saved support cost, the unit economics do not clear. Tune the sliders in `budget.html` before committing — start with cache hit % and model tier.

## Sensitivities

### 1. Worst-case usage spike (3× calls/user/day → 15 calls/user/day)
- Per-user-month: **$6.08**
- Monthly @ 100K: **$607,500**
- *What this tells you:* If "5 calls/day" is wrong by 3×, you are committing the business to half a million dollars a month at 100K users. Validate the usage assumption with real telemetry from the closest existing feature before scaling.

### 2. Model price drop 50%
- Per-user-month: **$1.01**
- Monthly @ 100K: **$101,250**
- *What this tells you:* Even at half the model price you're still at the threshold. Cost relief from model price drops alone is not enough — this feature needs structural changes (caching, batching, smaller model for the easy 80%), not a vendor discount.

### 3. Cache hit reaches 80%
- Per-user-month: **$0.59**
- Monthly @ 100K: **$58,500**
- *What this tells you:* Cache hit is the knob. At 80% input-token reuse the feature clears the $1 threshold with margin. Validate that 80% is achievable — email threads have high recurring context (same sender, same thread history) so it's plausible. Make "cache hit % ≥ 60%" the abandon-if metric in `/hypothesis-canvas`.

## The knob that moves the curve

Cache hit. The model-price-drop sensitivity barely clears the threshold; the usage-spike sensitivity blows past it. Only the cache-hit knob converts the feature from underwater to comfortably above water. The PM's pre-launch task is to prove the cache hit rate is achievable in production, not to negotiate a better price-per-token.

## Open the interactive calculator

`budget.html` in this folder — double-click. Sliders update live; localStorage saves your scenario; "Export JSON" hands the state to teammates.
