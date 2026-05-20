---
name: model-vs-rules-matrix
description: |
  Decision skill that takes a proposed AI feature description and produces a forced 5×3 trade-off matrix (5 dimensions: cost-at-scale, p95-latency, explainability, maintainability, failure-recovery × 3 approaches: pure-model, pure-rules, hybrid) with per-cell verdicts and 1–5 scores. Sums to a recommendation with explicit rationale, two "switch-your-answer-if" triggers, and a mandatory rules-first MVP describing what to ship before adding a model. Use when the user wants to: decide between an ML/LLM-based and a deterministic-rules implementation for a new feature, pressure-test an "of course it has to be a model" instinct, identify the rules-first MVP that could ship before the model arrives, or get a defensible architecture rationale for a design doc or PRD.

  Do NOT trigger for: features that have already shipped and need optimization (use a profiling/eval workflow instead), features where the underlying problem is still fuzzy (use problem-statement-doctor first), checking whether a model is *capable* of the task at all (use model-capability-mapper first), or sizing cost and latency budgets once an approach has been chosen (use cost-latency-budgeter).
---

# model-vs-rules-matrix (skill)

Decide model vs rules vs hybrid for a proposed AI feature by scoring every cell of a forced 5×3 matrix, then sequence the work with a mandatory rules-first MVP.

## Operating principles

- **Force the hybrid column.** Most shipped AI features are hybrid (rules-as-guardrail-around-a-model, or model-triggering-a-rules-engine). Always score all three columns — do not let the user collapse the choice to a binary.
- **Score every cell — no "depends" cop-outs.** Every cell gets an integer 1–5 and a one-sentence verdict. If the score genuinely depends on a condition, name the condition in a "switch-your-answer-if" trigger, not in the cell.
- **The rules-first MVP is mandatory output.** Even if the recommendation is pure-model or hybrid, you must produce a credible rules-first MVP and the trigger condition under which the model should be added on top. PMs need the sequencing option.
- **Explainability is load-bearing for high-stakes features.** Any cell where pure-model scores 1–2 on explainability AND the feature affects money, safety, or moderation gets flagged loudly in the recommendation — even if pure-model wins on points.
- **Never quietly recommend pure-model for high-stakes wrong answers.** If wrong outputs cost real money or harm users, the recommendation must explicitly name that risk and explain why the chosen architecture mitigates it.

## Inputs

- A proposed AI feature description, passed as `$ARGUMENTS` or pasted into the conversation. Should name: who uses it, what it does, how often, and (ideally) what happens if it's wrong.

If empty or under 15 words: respond with a single ask:

> "I need a fuller feature description to score trade-offs. Paste at least: (1) who uses the feature, (2) what it does, (3) roughly how often (per day/hour/request), (4) what happens if it's wrong. Even a rough paragraph is fine."

Do not proceed until the user provides one.

## Step 1 — Infer the stakes

Before scoring, classify the feature's stakes by reading the description for signals:

- **Money** — feature affects payments, pricing, billing, credit, refunds, ads spend, or revenue attribution.
- **Safety** — feature affects physical safety, medical/legal/financial advice, identity, or access to dangerous capabilities.
- **Moderation** — feature decides what content is shown, hidden, demoted, or escalated to humans.
- **Convenience** — wrong answers are annoying but recoverable (autocomplete, suggestions, search ranking on low-stakes content).

Record the stakes classification in a one-line "Stakes:" header. If money / safety / moderation: the explainability and failure-recovery dimensions will be weighted heavier in the recommendation.

## Step 2 — Load the dimensions

Read `assets/dimensions.md` (relative to this skill). It defines the 5 scoring dimensions with anchor descriptions for scores 1, 3, and 5. Use those anchors — do not invent your own scale.

## Step 3 — Score the 5×3 matrix

Build a markdown table with rows = dimensions, columns = approaches. Every one of the 15 cells gets:

- An integer score 1–5 (5 = best for this dimension under this approach).
- A 1-sentence verdict explaining *why* this approach scores that way for *this specific feature* (not a generic statement about models vs rules).

Format:

| Dimension | Pure-model | Pure-rules | Hybrid |
|-----------|------------|------------|--------|
| Cost-at-scale | 2 — Per-call LLM cost × 80k tickets/day = ~$X/mo. | 5 — Negligible compute; one-time rule authoring cost. | 3 — Rules cheap-path 70% of traffic; model handles 30%. |
| ... | ... | ... | ... |

At the bottom, sum each column: `Totals: Pure-model X/25 · Pure-rules Y/25 · Hybrid Z/25`. The highest total is the **point winner**. The point winner is the default recommendation unless a stakes-based override applies (Step 5).

## Step 4 — Spot the load-bearing cells

Identify and call out:

- **Any cell scoring 1 or 2** — these are the dealbreakers for that approach.
- **The dimension with the widest spread across approaches** — this is the trade-off the recommendation hinges on.
- **Explainability scores of 1–2 under pure-model when stakes ≠ convenience** — flag these loudly; they often override the point total.

## Step 5 — Write the recommendation

Produce a recommendation paragraph (3–5 sentences) that:

1. Names the recommended approach (model / rules / hybrid).
2. Cites the specific cell scores that drove the call — not generic talking points.
3. If stakes are money/safety/moderation AND pure-model has low explainability or low failure-recovery, the recommendation must call this out explicitly — even if pure-model is the point winner, recommend hybrid or rules and explain why the point total is misleading.
4. Names what the recommendation costs the PM (the trade-off they're accepting by picking this).

## Step 6 — Produce two "switch-your-answer-if" triggers

State two concrete, observable conditions under which a *different* column would win. Format:

- **Switch to [approach] if:** [specific condition with a number or threshold]. *Why:* [which cell flips and to what score].

Examples (do not reuse verbatim — generate from the actual feature):

- "Switch to pure-rules if: ticket-volume exceeds 500k/day. Why: cost-at-scale on pure-model drops from 2 to 1, and hybrid's 3 becomes a 2."
- "Switch to pure-model if: the rules library exceeds 200 hand-authored conditions. Why: maintainability on rules drops from 4 to 1."

## Step 7 — Produce the rules-first MVP

Mandatory section, regardless of the recommendation. Describe:

- **What ships:** the feature as a deterministic-rules-only implementation that could be built in one sprint. Be concrete — name the rule shape (regex / keyword tables / decision tree / weighted scoring / SQL classifier).
- **What it deliberately doesn't do:** the edge cases the rules will mis-handle.
- **Coverage estimate:** rough percentage of the input distribution the rules will handle correctly (call out the assumption).
- **"Promote to model when..." trigger:** the observable condition (volume threshold, accuracy ceiling, rule count, user complaint rate) under which adding the model becomes worth the cost.

## Step 8 — Write the output

Write everything to `model-vs-rules.md` in the current working directory. Structure:

```
# Model vs Rules vs Hybrid — <short slug from feature>

## Feature
> <verbatim input>

**Stakes:** <money | safety | moderation | convenience> — <one-line justification>

## Matrix
<5×3 table with per-cell score + verdict>

**Totals:** Pure-model X/25 · Pure-rules Y/25 · Hybrid Z/25
**Point winner:** <approach>
**Load-bearing cells:** <bulleted callouts from Step 4>

## Recommendation
<3–5 sentence paragraph from Step 5>

## Switch your answer if
- **Switch to <approach> if:** <condition>. *Why:* <which cell flips>.
- **Switch to <approach> if:** <condition>. *Why:* <which cell flips>.

## Rules-first MVP
**What ships:** <description>
**What it deliberately doesn't do:** <edge cases>
**Coverage estimate:** ~<X>% of the input distribution (assumption: <...>)
**Promote to model when:** <trigger>

## Notes
<flagged stakes-vs-explainability conflicts, weak inputs, scoping ambiguities>
```

After writing, report:

1. Absolute path to `model-vs-rules.md`.
2. The recommended approach and the column totals.
3. Whether a stakes-based override fired (and why).
4. Which downstream workflow to hand it to (e.g., "hybrid → `/cost-latency-budgeter` to size the model-path cost").

## How this skill differs from adjacent skills

- **`model-capability-mapper`** — answers "can a model do this at all?" (a binary capability check). This skill assumes the answer is yes and asks "should it?" against rules and hybrid alternatives.
- **`cost-latency-budgeter`** — once an approach is chosen, puts real dollar and millisecond numbers on it. This skill picks the approach; the budgeter sizes it.
- **`problem-statement-doctor`** — sharpens the *problem* before you spend cycles on the *solution architecture*. Run it first if the feature description is still fuzzy on who, what, or why.
- **Generic "model or rules?" prompts** — produce one verdict with no matrix. This skill forces all 15 cells, names the load-bearing trade-offs, and ships a rules-first MVP so the PM has a sequencing option.
