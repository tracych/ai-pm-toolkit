---
name: model-capability-mapper
description: |
  Triage skill that maps a PM's product idea onto a fixed matrix of 10 AI model families (LLM-frontier, LLM-open, vision-LLM, speech, recsys/ranking, world-models, 3D-generative, agents-with-tools, embeddings/retrieval, classical-ML), marks each as ENABLES / PARTIALLY-ENABLES / CANNOT-YET / NOT-RELEVANT with a one-line reason, identifies the 3 hardest capability cliffs the idea sits near, and recommends one primary family + one fallback + a < 1-week resolver experiment that produces a yes/no answer. Use when the user wants to: sanity-check whether a product idea is technically buildable with current AI, decide which model family to prototype against, surface the "cannot do this yet" boundaries before committing to a roadmap, or compare an idea against the current model-capability frontier.

  Do NOT trigger for: vendor selection or pricing comparisons (this names families, not vendors — use /cost-latency-budgeter for budgeting), debugging an already-shipped model's behavior, generating a product idea from scratch with no draft (ask for one first), or detailed model architecture questions (this is a PM triage tool, not an ML design doc).
---

# model-capability-mapper (skill)

Triage a product idea against the current AI model-capability frontier. Mark what's enabled, partially enabled, and not-yet-possible. Recommend one primary family, one fallback, and a cheap experiment that resolves the biggest unknown.

## Operating principles

- **Anchor on capability cliffs, not hype.** If frontier models can't reliably do something today, say so plainly — even if a viral demo exists. A demo is not a product.
- **Name the model family, not the vendor.** Use "frontier LLM," "open-weights LLM," "vision-LLM," etc. Vendor names age out in months; family names age out in years.
- **One primary, one fallback — no five-option hedges.** PMs need a decision. Pick the family with the best capability fit; pick the fallback that is materially worse on capability but materially safer on cost, latency, or risk.
- **Resolver experiments must produce a yes/no answer in under a week.** A spike, a prompt-eval, a wizard-of-oz, a small labeled set — not a quarter-long research project.
- **Never invent benchmarks.** Do not cite specific percentages, scores, or accuracies unless they are widely known. When stating a limit, qualify with "as of [current model generation]" and describe the failure mode in concrete behavioral terms ("drifts after ~5 sequential steps", "hallucinates citations on unseen documents") instead of fake numbers.

## Inputs

- A product idea, passed as `$ARGUMENTS` or pasted into the conversation.

If empty or under 15 words: respond with a single ask:

> "I need a fuller paragraph to map. Paste at least: (1) who the user is, (2) what they're trying to do, (3) what the AI is doing in the loop, (4) where it runs (device, web, etc.). One paragraph is fine."

Do not proceed until the user provides one.

## Step 1 — Load the model-family reference

Read `assets/model-families.md` (relative to this skill). It defines the canonical 10 families with capability anchors describing what each one can and cannot reliably do as of the current model generation. Use those anchors — do not invent new families or rename them.

## Step 2 — Build the 10-row capability matrix

For each of the 10 families, assign one verdict and write a one-line reason tied to the actual idea text:

- **ENABLES** — this family can reliably do the core thing the idea needs.
- **PARTIALLY-ENABLES** — this family covers part of the idea but has a known gap that would need a workaround or another family alongside.
- **CANNOT-YET** — current models in this family demonstrably fail at the required behavior; not a question of prompting harder.
- **NOT-RELEVANT** — this family has nothing to do with what the idea is asking for.

Format as a markdown table:

| # | Model family | Verdict | Reason |
|---|--------------|---------|--------|
| 1 | LLM-frontier | ENABLES | Step-by-step explanation of a geometry proof is well within current capability. |
| ... | ... | ... | ... |

Be specific in the reason. Quote a phrase from the idea when possible. Do not write "depends on use case" — pick a verdict.

## Step 3 — Identify the 3 capability cliffs

Pick the three hardest "the model has to be able to X but reliably can't yet" risks the idea sits near. Each cliff is a behavior, not a model. Format:

### Cliff 1: <short name>
- **What the idea needs:** <concrete behavior>
- **Why it's a cliff:** <how current models fail at this — drift, hallucination, latency, modality gap, etc.>
- **How close are we:** "On the edge" / "A generation away" / "Architecturally unsolved" — pick one.

Do not invent benchmark numbers. Describe failure modes behaviorally. If the idea has fewer than 3 real cliffs, say so and list only the real ones — do not pad.

## Step 4 — Recommend primary + fallback

Pick exactly one **primary** model family and exactly one **fallback**.

- **Primary:** the family with the best capability fit for the core loop. State the family and a one-sentence rationale anchored in the matrix.
- **Fallback:** a different family (or composition, like "embeddings/retrieval + classical-ML") that ships a meaningfully degraded but still useful version if the primary fails on cost, latency, accuracy, or availability. State what gets lost in the trade.

Do not list more than two. Do not hedge.

## Step 5 — Design the resolver experiment

Design one experiment that resolves the **biggest** cliff (the one most likely to kill the idea) in under one week. It must:

- Be runnable by one PM + one engineer in ≤ 5 working days.
- Produce a **yes/no** answer to a specific question — not a "let's explore further."
- Use cheap inputs: a small labeled set, a prompt-eval, a wizard-of-oz prototype, a benchmark on 20–50 representative cases, an off-the-shelf API spike.

Format:

- **The question:** "Can a [family] reliably [behavior] on [input type]?"
- **The setup:** <one paragraph describing the rig — what you'll feed in, what you'll measure>
- **Pass criterion:** <specific observable that means yes>
- **Fail criterion:** <specific observable that means no>
- **Why this resolves the cliff:** <one sentence>

## Step 6 — Write the output

Write everything to `model-capability-map.md` in the current working directory. Structure:

```
# Model Capability Map — <short slug from idea>

## Idea
> <verbatim input>

## Capability matrix
<10-row table>

## Capability cliffs
### Cliff 1: <name>
...
### Cliff 2: <name>
...
### Cliff 3: <name>
...

## Recommendation
**Primary:** <family> — <rationale>
**Fallback:** <family> — <what gets lost>

## Resolver experiment
**Question:** ...
**Setup:** ...
**Pass:** ...
**Fail:** ...
**Why this resolves the cliff:** ...

## Notes
<caveats, unknowns, things you flagged but did not score>
```

After writing, report:

1. Absolute path to `model-capability-map.md`
2. The primary + fallback families
3. The single cliff the resolver experiment is aimed at

## How this skill differs from adjacent skills

- **`/problem-statement-doctor`** — pressure-tests the *problem* framing. model-capability-mapper pressure-tests the *technical feasibility* of a candidate solution. Run problem-statement-doctor first.
- **`/cost-latency-budgeter`** — once you've picked a model family, budgets tokens, latency, and unit economics. model-capability-mapper picks the family; the budgeter sizes the bill.
- **Generic "is this possible with AI?" prompts** — produce hand-wavy yes-but-it-depends answers. This skill forces a per-family verdict, names the cliffs concretely, and ends with a runnable experiment.
