# Model Tiers — cost and latency reference

**As of 2025-2026, verify before quoting.** LLM provider pricing changes quickly. These numbers are intentionally rounded, conservative, and presented as ranges. Always confirm against the provider's pricing page before putting any of this in a launch review, board memo, or PRD.

Costs are per **1M tokens** (USD). Latency is for a single non-batched, non-streamed call from a typical cloud region; first-token includes any cold-start jitter at the high end.

| Tier | Examples (illustrative) | Input $/M (low–high) | Output $/M (low–high) | First-token ms (low–high) | Tokens/sec (low–high) |
|------|--------------------------|----------------------|------------------------|----------------------------|------------------------|
| **frontier** | Top-tier hosted reasoning models (e.g., flagship Claude / GPT / Gemini at the time of writing) | 3 – 15 | 15 – 75 | 400 – 1500 | 30 – 80 |
| **mid** | Default workhorse hosted models, balanced cost/quality | 0.5 – 3 | 1.5 – 15 | 200 – 800 | 60 – 150 |
| **small** | Hosted small/fast tier, optimized for throughput and short tasks | 0.05 – 0.5 | 0.15 – 2 | 100 – 400 | 100 – 300 |
| **open** | Self-hosted open-weight models (Llama-class, Mistral-class) on your own GPUs; amortized $/token depends heavily on utilization | 0.02 – 0.30 | 0.05 – 0.60 | 50 – 500 | 50 – 250 |

## Notes on use

- **Plan against the high end of cost.** PMs default to optimism; the high end of the range is the realistic "what happens when traffic isn't perfectly cache-friendly" cost.
- **Frontier models charge for thinking tokens too.** If you're using a reasoning model, multiply output tokens by ~1.5–3× to account for chain-of-thought tokens that you pay for but the user never sees.
- **Open-weight models trade $/token for fixed GPU spend.** The $/M numbers above only make sense at high utilization (>50%). At low utilization, your effective $/token is much higher because you're paying for idle GPUs.
- **Prompt caching can drop input cost 50–90%** on cache hits, depending on provider. The HTML calculator's "cache hit %" slider models this — set it conservatively.
- **Batching helps cost more than latency.** Batched APIs are typically 50% off list price but add minutes to hours of latency. Use for offline/async features only.

## Latency math the calculator assumes

```
p95 = retrieval_ms (default 50 if RAG-ish, else 0)
    + first_token_ms (upper end of the tier range)
    + (output_tokens / tokens_per_sec_lower) × 1000
    + network_ms (default 100)
    + retry_rate × retry_penalty_ms (retry_penalty ≈ base latency)
```

## Refresh policy

When provider prices materially change, update the ranges above and bump the "as of" date at the top. Until then: **verify before quoting.**
