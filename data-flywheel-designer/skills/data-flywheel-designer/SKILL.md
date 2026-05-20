---
name: data-flywheel-designer
description: |
  Design skill that turns a one-line AI feature description (model type + user interaction shape) into a complete 6-stage data flywheel: cold-start data plan, signal capture, labeling pipeline, storage & schema, retraining trigger, and safe re-deploy. Each stage gets a concrete plan plus an explicit "failure mode if you skip this" note. The skill quantifies the retraining trigger and labeling cost (placeholder numbers allowed, but they must be numbers, not vibes) and emits both a markdown design doc and a single-file HTML diagram (6 stages as a cycle, contenteditable boxes, localStorage persistence, no CDN). Use when the user wants to: design how their AI feature collects training data from real usage, figure out what to log to power future retraining, pressure-test whether a planned AI product actually has a flywheel, or sequence cold-start vs steady-state data work.

  Do NOT trigger for: writing the AI feature spec itself (use ai-feature-spec), curating a static eval set (use eval-set-curator), investigating why a model is wrong on specific inputs (use hallucination-profiler), or estimating cost/latency of inference (use cost-latency-budgeter). Also do NOT trigger for stateless one-shot LLM calls with no notion of "improving from usage" — there is no flywheel to design.
---

# data-flywheel-designer (skill)

Design the data-collection loop that makes an AI feature improve from real usage. Six stages, every one mandatory, every one with a quantified plan and a named failure mode.

## Operating principles

- **Cold-start is the #1 thing PMs skip.** Most flywheels never spin because v0 has no data. The cold-start row must name a concrete source (synthetic generation, scraping, hand-curated seed set, transfer-learning from a public model, prompted-LLM-as-baseline). "We'll figure it out at launch" is not allowed — push back and ask which one.
- **Implicit signals beat explicit feedback on volume.** Explicit thumbs-up/down rates are typically under 1% of sessions. Always include at least one implicit signal in the signal-capture row (dwell time, retry, edit-after-accept, accept-without-modification, downstream conversion).
- **"Human-in-the-loop" without a labeling-cost-per-week estimate is not a plan, it's a hope.** The labeling row must include either ($/label × labels/week) or a named internal team with allocated hours/week. If unknown, use bracketed placeholders like `[$0.50/label × 2,000/week = $1,000/wk]` — but the shape of the number must be there.
- **Quantify the retraining trigger.** Not "when we have enough data" — name a threshold: N new labeled samples, M weeks, K-point drop on the eval set, or a logical combination ("1,000 new labels OR 5pp eval drop, whichever first").
- **Closing the loop has a safety story.** Every flywheel design must name a re-deploy guardrail: shadow-mode, A/B at X%, gradual ramp with auto-rollback on metric Y. Auto-deploying a retrained model with no shadow is how products silently regress.

## Inputs

- An AI feature description, passed as `$ARGUMENTS` or in conversation. Must include:
  - **Model type / task** (e.g., "ranker", "LLM-generated summary", "classifier", "embedding retrieval", "fine-tuned instruction model").
  - **User interaction shape** (what the user *does* in response to the model — accept/reject, edit, click, dwell, navigate away, etc.).

If either is missing, respond with a single ask:

> "I need two things to design the flywheel: (1) the model type or task (ranker / generator / classifier / retriever / fine-tuned LLM / etc.), and (2) what the user actually does with the output (accept, edit, dismiss, click, dwell, ignore). Without the interaction shape, there's no signal to capture."

Do not proceed until the user provides both.

## Step 1 — Load the stages reference

Read `assets/flywheel-stages.md` (relative to this skill). It defines each of the 6 stages with options, the failure mode if skipped, and signal/source examples. Use those definitions — do not invent your own stage list or re-order them.

## Step 2 — Design each of the 6 stages

For each stage, produce three fields:

- **Plan** — concrete, named-source / named-signal / named-threshold. No "we'll consider X" hedging.
- **Why this choice** — one sentence tying the plan to the feature's specific interaction shape.
- **Failure mode if skipped** — one sentence naming what breaks if this stage is missing or vague (pull from `flywheel-stages.md` and specialize to the feature).

Stage order is fixed:

1. **Cold-start data plan** — where v0 training data comes from before launch.
2. **Signal capture** — explicit + implicit + derived signals the live product will log.
3. **Labeling pipeline** — auto-label vs human-in-the-loop, with cost/throughput numbers.
4. **Storage & schema** — what fields get logged per call, retention window, PII handling.
5. **Retraining trigger** — quantified condition that fires a retrain.
6. **Closing the loop** — how the new model gets deployed safely (shadow / A/B / canary / ramp).

## Step 3 — Sequencing note

After the 6 stages, write a short **"What to build first"** section (3–5 bullets) covering:

- What must exist *before* launch (typically: cold-start dataset + storage schema + at least one implicit signal in the logger).
- What can wait until N weeks post-launch (typically: human labeling queue, retraining trigger automation, shadow-deploy infrastructure).
- The one dependency that, if late, blocks everything else.

## Step 4 — Write the markdown output

Write to `data-flywheel.md` in the current working directory. Structure:

```
# Data Flywheel — <short slug from feature description>

## Feature
- **Model / task:** ...
- **User interaction:** ...

## The 6 Stages

### 1. Cold-start data plan
- **Plan:** ...
- **Why this choice:** ...
- **Failure mode if skipped:** ...

### 2. Signal capture
- **Plan:** ... (must include at least one implicit signal)
- **Why this choice:** ...
- **Failure mode if skipped:** ...

### 3. Labeling pipeline
- **Plan:** ... (must include $/label × labels/week OR named team + hours)
- **Why this choice:** ...
- **Failure mode if skipped:** ...

### 4. Storage & schema
- **Plan:** ...
- **Why this choice:** ...
- **Failure mode if skipped:** ...

### 5. Retraining trigger
- **Plan:** ... (must be quantified — N samples / M weeks / K-pp eval drop)
- **Why this choice:** ...
- **Failure mode if skipped:** ...

### 6. Closing the loop
- **Plan:** ... (must name a safety mechanism — shadow / A/B / ramp / auto-rollback)
- **Why this choice:** ...
- **Failure mode if skipped:** ...

## What to build first
- ...
- ...

## Open questions
- ...
```

## Step 5 — Write the HTML diagram

Read `assets/flywheel_diagram_template.html` and copy it to `flywheel.html` in the current working directory, with one substitution: replace each placeholder block (marked `<!-- PLAN:1 -->` through `<!-- PLAN:6 -->`) with the **Plan** text from the corresponding stage.

The template is self-contained: no CDN, no external CSS, no JS framework. It uses inline SVG for the cycle arrows and `contenteditable` divs for the 6 stage boxes, persisting edits to `localStorage` under key `data-flywheel-designer`. Do not modify the template's structure — only fill in the plan text.

## Step 6 — Report back

After writing both files, report:

1. Absolute paths to `data-flywheel.md` and `flywheel.html`.
2. The two stages with the weakest specificity (the ones most likely to be hand-waved later).
3. Which adjacent skill to chain next based on what looks underspecified:
   - If signal capture is vague → `/ai-feature-spec` to nail down telemetry.
   - If labeling cost is hand-wavy → `/cost-latency-budgeter`.
   - If you don't yet know which slices to prioritize → `/hallucination-profiler`.

## How this skill differs from adjacent skills

- **`/ai-feature-spec`** — defines *what the AI feature does and what telemetry it emits*. data-flywheel-designer takes that telemetry and designs the *loop* (labeling, retraining, re-deploy). Spec is the inputs; flywheel is the system that turns them into a better model.
- **`/eval-set-curator`** — builds a *static* held-out set to measure quality. data-flywheel-designer designs the *flow of new data* that the eval set will eventually be expanded from.
- **`/hallucination-profiler`** — diagnoses *where* a model is wrong on specific inputs. data-flywheel-designer decides what to *log and label* so those wrong cases can be retrained against.
- **`/cost-latency-budgeter`** — sizes inference cost. data-flywheel-designer surfaces the labeling-cost line item that the budgeter then absorbs.
- **Generic "how should we collect data" prompts** — produce a paragraph with no stage structure, no quantified trigger, no failure modes, and no diagram. This skill enforces all four.
