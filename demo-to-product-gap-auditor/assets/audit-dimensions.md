# Demo-to-Product Audit Dimensions

Ten dimensions. Score each 1–5 using the anchors below. Always tie the score to something concrete in the demo description. A dimension scoring 4 is shippable with a documented gap and an owner; 5 is "no known concerns."

Common gap patterns are listed for each dimension — use them as a starting point, not a script.

---

1. **Latency at scale** — Will p50 and p95 hold when 100× the demo's current traffic hits the same endpoint?
   - 1: Demo runs single-user, synchronous; no latency measurements taken; uses a model whose published p95 is already at the edge of the UX target.
   - 3: Measured latency on the happy path under demo load; haven't tested concurrency, retrieval pile-up, or cold-start; no defined SLO.
   - 5: Defined p50/p95 SLO, load-tested at projected launch concurrency, has a degradation strategy (smaller model, cached path, queueing) if SLO breaches.
   - Common gaps: streaming not implemented so users stare at a spinner; retrieval k=20 was fine for one user but melts at 50 QPS; no timeout configured so a slow upstream stalls the whole UX.

2. **Cost at scale** — Is the per-request and per-user-per-month cost known, modeled at launch volume, and approved by whoever holds the budget?
   - 1: No cost model; the team hand-waves "tokens are cheap"; no budget owner has signed off.
   - 3: Per-request cost measured; multiplied by audience size; nobody has decided what happens when the bill is 3× expected.
   - 5: Per-user and total monthly cost modeled with a sensitivity range; budget owner approved; circuit breaker or cheaper-model fallback wired in if spend exceeds threshold.
   - Common gaps: cost modeled on average tokens but power-user tail blows the budget; no per-user rate limit; context window is generous "just in case" and doubles the bill.

3. **Eval coverage** — Is there an offline eval set that covers the segments that matter, with a measurable pass bar, that runs before every release?
   - 1: No eval set; quality assessed by founder vibes on 3 examples.
   - 3: Eval set exists for the happy path; covers maybe one persona; no defined pass bar; not wired to CI.
   - 5: Eval set covers the top user segments and the known failure modes; has a defined pass bar; blocks release if regression detected; refreshed when new failure patterns surface.
   - Common gaps: evals only cover examples the demo already passes; no adversarial / edge-case coverage; pass bar is "looks good" not a number.

4. **Abuse defense** — What stops a motivated user (or a curious one) from using this to do something embarrassing, illegal, or off-brand?
   - 1: No input filtering, no output filtering, no rate limits, no audit log; the only defense is "users probably won't try."
   - 3: Off-the-shelf content moderation on input or output (not both); known categories like CSAM/violence covered; product-specific abuse (jailbreaks, brand-damaging outputs, PII exfiltration) not tested.
   - 5: Red-teamed against the top abuse vectors for this product surface; input + output guards in place; rate limits per user; audit log retained; defined response playbook for confirmed abuse.
   - Common gaps: prompt-injection wide open via retrieval content; users can paste another person's data and ask for analysis; no logging means abuse is invisible until it's a screenshot on Twitter.

5. **Monitoring** — When the feature is broken in production, will the team find out from a dashboard, or from a customer?
   - 1: No model-specific metrics; the only signal is generic infra uptime; "broken" means "the server is down," not "the model is wrong."
   - 3: Latency + error rate dashboards exist; no quality drift signal; no alerting on cost spike, eval regression, or fallback rate.
   - 5: Dashboards cover latency, error rate, cost, fallback rate, user-visible quality signal (CSAT, thumbs, retry rate); alerts wired to a real channel a human reads; SLOs defined and reviewed.
   - Common gaps: monitoring assumes the model returns 200s — silent quality regressions invisible; nobody is paged when the cost dashboard ticks up 3×; "monitoring" lives in Datadog but nobody opens it.

6. **Fallback** — When the model fails (timeout, error, unsafe output, low confidence), what does the user see, and is it explicitly designed?
   - 1: No fallback; the request fails or the UI hangs; user sees a stack trace or nothing.
   - 3: There's a generic error message; not tailored to the failure type; no graceful degradation to a non-AI path; no retry policy.
   - 5: Explicit fallback policy per failure type — timeout → cached or smaller model; unsafe output → blocked + neutral message; low confidence → "we're not sure, here's the manual path"; UX tested for each.
   - Common gaps: "the spinner just spins"; error message is the raw API error; no non-AI fallback exists so users are stuck when the model is down.

7. **UX trust signals** — Does the UI tell users what the AI did, how confident it is, and how to recover from a bad output?
   - 1: No indication the response is AI-generated; no confidence signal; no easy way to disagree, edit, or report.
   - 3: Says "AI-generated" somewhere; thumbs-up/down exists but nobody acts on the feedback; no inline confidence or sourcing.
   - 5: Clear AI-attribution; surfaces sources/citations or "I'm not sure" when applicable; easy edit + report flow; feedback loops back to evals.
   - Common gaps: outputs look authoritative even when fabricated; thumbs feedback collected but never reviewed; no "edit this" so users either accept or abandon.

8. **Comms readiness** — Are the launch comms written, including a credible story for what we say when the model is wrong?
   - 1: No launch comms drafted; nobody has thought about external messaging or what to say when things go sideways.
   - 3: Launch announcement drafted; positions the feature glowingly; has zero acknowledgment of limitations or failure modes; no holding statement for incidents.
   - 5: Launch comms drafted with named limitations, an honest "here's what AI is good and bad at" framing, a pre-approved incident-response statement, and the team aligned on what *not* to claim.
   - Common gaps: comms imply 100% accuracy; no holding line for "the model said something wrong"; PR/marketing not looped in on failure scenarios.

9. **On-call story** — Who gets paged at 2am when this breaks, and do they have a runbook?
   - 1: No on-call rotation; by default, the founding PM and the lead engineer are the rotation; no runbook.
   - 3: Rotation exists but only covers infra; nobody is responsible for "the model is hallucinating in prod"; no model-specific runbook.
   - 5: Named rotation that owns the AI feature end-to-end; runbook with top-N failure modes and remediation (kill switch, model swap, rollback); rotation has actually been tested with a drill.
   - Common gaps: oncall expectations unclear so nobody acts; runbook says "investigate" with no concrete first step; no kill switch so the only mitigation is a code revert.

10. **Retrain story** — When the model needs an update — new failure mode, model deprecation, drift — is there a defined path to ship the change without a fire drill?
    - 1: No retrain story; the team will deal with it when the provider sunsets the model; no captured training data; no eval baseline to compare against.
    - 3: Some labeled data is being collected; no defined cadence for refresh; provider model swap would require a rewrite of prompts.
    - 5: Defined cadence (monthly / quarterly / triggered by drift); labeled data flow into eval set + (where applicable) fine-tuning pipeline; prompts versioned and abstracted enough to swap models without rewriting calling code; rollback path exists.
    - Common gaps: prompts are hardcoded against one model's quirks; no plan for when the provider deprecates the model in 6 months; "we'll fine-tune later" with no data being collected today.
