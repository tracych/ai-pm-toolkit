# Demo-to-Product Gap Audit — sales-rep-cold-outreach-drafter

**Verdict:** STILL A DEMO
**Score:** 24 / 50
**Dimensions at 1–2:** 6

> **This is not yet a product.** Six of ten readiness dimensions are at 1–2. Do not draft launch comms or schedule the rollout until at least four of these clear 3/5. The team's instinct that "it works in the demo" is correct and irrelevant — demos do not have 200 sales reps hitting them at 9am Monday.

## Must-fix before launch (top 3)

1. **On-call story (score: 1/5)** — No rotation exists; current plan is "ping the founding PM in Slack if it breaks." Minimum fix: name a primary + secondary on-call for the first 30 days post-launch, write a 1-page runbook with a kill switch (feature flag to disable the AI path), test the kill switch in staging. **Owner:** _____
2. **Abuse defense (score: 1/5)** — No input or output filtering; reps can paste a competitor's customer list and ask for personalized outreach against them. Minimum fix: input PII/competitor-domain detector + output content moderation API + per-rep rate limit (e.g., 50 drafts/day) + audit log retained 90 days. **Owner:** _____
3. **Eval coverage (score: 2/5)** — Two hand-curated examples in a Notion doc; no segment coverage; no pass bar; nothing runs before deploy. Minimum fix: build a 30-example eval set covering the 3 top customer segments + 5 known failure modes (factual errors about prospects, off-brand tone, made-up case studies), define a pass bar (e.g., ≥80% rated 3+ by a sales lead), wire it to run before each prompt change. **Owner:** _____

## Full scorecard

| # | Dimension | Score | Gap | Minimum fix |
|---|-----------|-------|-----|-------------|
| 1 | Latency at scale | 3/5 | Demo measured at 1 user; GPT-4o p95 at projected 50 QPS unknown; no streaming so reps watch a 6s spinner. | Load test at 50 QPS; turn on token streaming so first-token latency is what matters; define p95 SLO of 4s first-token. |
| 2 | Cost at scale | 2/5 | Per-draft cost (~$0.04) modeled, but no per-rep cap and no monthly budget owner signed off. Power users could 10× the bill. | Set per-rep daily cap; model monthly cost at p50/p95 usage; get RevOps to sign the budget; circuit-breaker if monthly spend > 1.5× plan. |
| 3 | Eval coverage | 2/5 | Two examples in a Notion doc; no segment or failure-mode coverage; no pass bar; nothing runs in CI. | 30-example eval covering 3 segments + 5 failure modes; pass bar ≥80% rated 3+ by sales lead; runs before each prompt change. |
| 4 | Abuse defense | 1/5 | No input filters, no output filters, no rate limits, no audit log. Reps can request outreach against competitors' customers. | Input PII/competitor detector + output moderation + 50/day rate limit + 90-day audit log. |
| 5 | Monitoring | 2/5 | Infra uptime monitored; no model-specific metrics; nobody knows when drafts get worse. | Dashboards for: latency p95, error rate, cost, thumbs-down rate, fallback rate. Alert thumbs-down >15% to #ai-outreach-launch. |
| 6 | Fallback | 1/5 | Model error = blank screen with a stack trace. No non-AI fallback to manual draft. | Explicit error UI ("Draft service unavailable — write manually"); pre-canned template fallback for timeouts; tested in staging. |
| 7 | UX trust signals | 3/5 | "AI-generated, please review" banner present; no inline confidence; no easy edit-and-resend flow; thumbs collected but nobody reads them. | Add edit-in-place; pipe thumbs into a weekly review by the sales lead; flag low-confidence drafts ("verify prospect's company name"). |
| 8 | Comms readiness | 2/5 | Internal launch email drafted; positions the tool as "AI that nails cold outreach"; no acknowledgment of failure modes; no holding statement if a rep sends an embarrassing draft. | Rewrite comms with limitations callout; pre-approved holding line for incidents; loop in PR/Legal on what reps must not claim ("AI wrote this for you"). |
| 9 | On-call story | 1/5 | No rotation. Founding PM is implicit oncall. No runbook. No kill switch. | Named primary + secondary for 30d; 1-page runbook with top-5 failure modes; feature flag kill switch tested in staging. |
| 10 | Retrain story | 2/5 | Prompts hardcoded against GPT-4o quirks; no labeled outcome data being collected (did the prospect reply?); no plan for when the model is deprecated. | Log draft + send + reply outcome; abstract prompts behind a model adapter so swaps don't require rewrites; quarterly review of failure-mode shifts. |

## If verdict is STILL A DEMO

Do not ship yet. The following dimensions need to clear 3/5 before launch comms make sense:
- On-call story (1 → 3): name rotation + runbook + kill switch.
- Abuse defense (1 → 3): input/output guards + rate limit + audit log.
- Fallback (1 → 3): explicit failure UI + non-AI fallback path.
- Cost at scale (2 → 3): per-user cap + budget owner sign-off.
- Eval coverage (2 → 3): 30-example eval + pass bar + wired to CI.
- Comms readiness (2 → 3): limitations callout + incident holding line.

When at least four of these clear 3/5 (and none are still at 1), re-run `/demo-to-product-gap-auditor` and re-evaluate.

## Next steps (chain to other skills)

- Cost at scale → `/cost-latency-budgeter` to model per-rep and total monthly cost at p50/p95 usage.
- Eval coverage + UX trust → `/hallucination-profiler` to enumerate concrete failure modes for the eval set.
- Abuse defense → `/ai-redteam-prompts` to generate the adversarial corpus that exercises the input/output guards.
- On-call + monitoring → `/rollback-planner` to design the kill switch and on-call response plan.
- Comms readiness → `/comms-pack` to rewrite the launch announcement with the limitations callout + incident holding line.
