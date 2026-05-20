---
description: Build a back-of-envelope per-user-month cost and p95 latency model for a proposed AI feature, with tunable sliders for model tier, cache hit, batching, and retries.
argument-hint: "[feature description + DAU + calls/user/day + ~input tokens + ~output tokens]"
---

Load the `cost-latency-budgeter` skill and run its modeling workflow.

Feature description (may be empty — if so, ask the user for the required inputs): $ARGUMENTS

Follow the skill exactly:
- If the user has not supplied DAU, calls/user/day, and rough input/output token sizes, refuse and list what's missing.
- Compute the baseline: per-call cost, per-user-month cost, monthly totals at 10K / 100K / 1M users, p95 pipeline latency.
- Write three sensitivity scenarios: worst-case usage spike, model price drop 50%, cache hit reaches 80%.
- Emit `budget.html` (interactive, no CDN), `budget.md`, and `budget.json` under `cost-latency-budgeter/budgets/<slug>/`.
- Banner the HTML red if per-user-month cost exceeds the configured threshold.
