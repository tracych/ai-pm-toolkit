# The 6 Flywheel Stages

Every AI feature that learns from real usage needs all six. Skip one and the loop stalls. For each stage: a definition, the options, and the most common failure mode if the PM hand-waves it.

1. **Cold-start data plan** — Where v0 training data comes from *before* a single real user touches the product.
   - **Options:** synthetic generation (LLM-produced examples), public dataset / scraping, hand-curated seed set (10s–100s of expert examples), transfer learning from an existing model, prompted-LLM-as-baseline (no training, just a strong prompt as the v0 system).
   - **What goes in the plan:** the specific source, rough sample count, who produces it, and the licensing / compliance check.
   - **Failure mode if skipped:** the flywheel never spins. There's no v0 to capture signal against, so the entire labeling and retraining apparatus has nothing to attach to. PMs ship a "we'll collect data once it's live" story and then discover at week 4 that without a v0 model, nobody used the feature enough to generate the data they were waiting for.

2. **Signal capture** — Which user actions encode preference, logged on every model call.
   - **Options:**
     - *Explicit:* thumbs up/down, star rating, "report problem", written feedback.
     - *Implicit:* dwell time, accept-without-edit, edit-after-accept, retry / regenerate, dismiss, skip, scroll-past, navigate-away.
     - *Derived:* downstream conversion, task completion, repeat use, second-session return, undo events.
   - **What goes in the plan:** at least one signal from each of the three categories (explicit + implicit + derived), the event name, and which field stores the model output it refers to.
   - **Failure mode if skipped:** you log the model's outputs but not the user's reactions, so when it's time to retrain you have inputs without targets. Or you log only explicit feedback (sub-1% response rate) and have a statistically useless signal stream.

3. **Labeling pipeline** — How raw logged events become labeled training data.
   - **Options:** fully auto-labeled from implicit signals (e.g., "accepted without edit = positive"), human-in-the-loop with internal team, human-in-the-loop with outsourced labelers, model-assisted labeling (LLM proposes, human confirms), active learning (queue only high-uncertainty samples).
   - **What goes in the plan:** the labeling method, the per-label cost or per-week internal hours, the queue prioritization rule, and the quality-control mechanism (gold sets, inter-rater agreement spot checks).
   - **Failure mode if skipped:** the labeling budget shows up as a surprise line item in Q3, or labelers churn through low-quality samples and the retrained model is worse than v0. "Human-in-the-loop" with no cost number is the single most common form of hand-wave in AI PRDs.

4. **Storage & schema** — What gets persisted per model call, for how long, and with what privacy posture.
   - **Options:** log everything raw (cheap to start, expensive to comply with later), log structured fields only, log with PII scrubbing on write, separate hot store (recent) from cold store (archival).
   - **What goes in the plan:** the schema (input, output, user-action signals, model version, timestamp, request ID), retention window in days, and the PII handling rule (scrubbed on write, hashed user IDs, opt-out honored).
   - **Failure mode if skipped:** six months in, the team wants to retrain on richer features but the missing fields were never logged — and there's no way to backfill historical user behavior. Or worse, you logged PII you weren't supposed to and have a compliance incident.

5. **Retraining trigger** — The quantified condition that fires a new training run.
   - **Options:** sample-count threshold (every N new labeled samples), time-based (every M weeks), performance-drop (eval-set win-rate drops K points), drift-based (input distribution shift detected), event-driven (after a known model failure / launch / population change), or a combination ("N samples OR K-point drop, whichever first").
   - **What goes in the plan:** the specific threshold(s), who or what monitors them, and where the alert / job ticket lands.
   - **Failure mode if skipped:** retraining happens whenever someone remembers to ask, which is never. The model decays silently, and the team only notices when an exec complains about a specific bad output six months in.

6. **Closing the loop** — How a retrained model gets back to users without silently regressing the experience.
   - **Options:** shadow mode (new model scored offline against the old model's traffic), A/B test at X% of traffic, gradual ramp (1% → 5% → 25% → 100% with auto-rollback on guardrail metric), canary on internal users first, holdout that never gets the new model so long-term drift is measurable.
   - **What goes in the plan:** the specific deploy strategy, the guardrail metric and threshold, and the rollback owner / mechanism.
   - **Failure mode if skipped:** a "better" model on the eval set ships and tanks a downstream business metric nobody was watching. The team has no rollback playbook, so the regression sits in production for a week while they debate whether to revert.
