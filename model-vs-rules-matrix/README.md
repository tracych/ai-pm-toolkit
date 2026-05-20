# model-vs-rules-matrix

For a proposed AI feature, decide whether to use a model, deterministic rules, or a hybrid — with a forced trade-off matrix across cost, latency, explainability, maintainability, and failure recovery.

## What it does

Takes a description of a proposed AI feature and runs it through a forced architectural triage:

1. **Builds a 5×3 matrix** — 5 dimensions (cost-at-scale, p95-latency, explainability, maintainability, failure-recovery) × 3 approaches (pure-model, pure-rules, hybrid). Every cell gets a 1-sentence verdict and a 1–5 score. No "depends" cop-outs — if it depends, the condition gets named in the recommendation.
2. **Sums to a recommendation** — a winning column with explicit reasoning tied to the cell scores, plus two **"switch-your-answer-if"** triggers naming the conditions under which a different column wins.
3. **Emits a rules-first MVP** — the version of the feature you could ship next sprint with no model at all, so the PM has a sequencing option before they commit to a model roadmap.

The output is one `model-vs-rules.md` in your working directory. Drop it in a PRD, attach it to an architecture review, or hand it to engineering as the "why this shape" memo.

## Use it

In Claude Code (with this repo in your workspace):

```
/model-vs-rules-matrix Auto-categorize inbound support tickets into 12 product-area buckets and route to the right team within 30 seconds of submission
```

Or paste a longer feature description into the conversation and let the skill auto-trigger on phrasing like "should this be a model or rules?", "model vs heuristic for X", "build vs LLM-call for this feature".

If your description is fewer than 15 words, the skill will refuse and ask you to elaborate — there's not enough surface area to score trade-offs against a fragment.

## Output

`model-vs-rules.md` in your current working directory, containing:

- The feature description (verbatim) and the inferred stakes (money / safety / moderation / convenience)
- A 5×3 matrix with per-cell verdict + score, column totals, and a winner
- A recommendation paragraph with explicit rationale referencing cell scores
- Two **"switch-your-answer-if"** triggers
- The **rules-first MVP** description: what to ship before adding the model, with the "promote to model when..." trigger

## When NOT to use

- The feature has already shipped and you're optimizing it — use a profiling/eval workflow, not an architecture triage.
- You haven't validated the problem yet — run `/problem-statement-doctor` and `/pm-deep-dive` first.
- You don't yet know whether a model *can* do the task at all — run `/model-capability-mapper` first to bound the model's reach.
- You've already chosen the approach and need to size the bill — use `/cost-latency-budgeter`.

## Operating principles

- **Force the hybrid column.** Most shipped AI features are hybrid (rules guardrail a model, or a model triggers a rules engine). Pretending the choice is binary loses the real design.
- **Score every cell — no "depends" cop-outs.** If it depends on a condition, the condition belongs in the "switch-your-answer-if" triggers, not in the cell.
- **The rules-first MVP is mandatory output.** Many features ship faster as rules and *later* add a model. The sequencing question is as important as the architecture question.
- **Explainability matters more than PMs think.** Any cell where pure-model scores 1–2 on explainability AND the feature touches money, safety, or moderation gets a loud flag in the recommendation.
- **Never quietly recommend pure-model for high-stakes features.** If wrong answers cost real money or harm users, the recommendation must name that risk explicitly even when pure-model wins on points.

## Composes with

- **`/model-capability-mapper`** — run *first* to confirm a model *can* perform the task at acceptable quality. If it can't, the matrix collapses to rules and you can skip this skill.
- **`/cost-latency-budgeter`** — run *after* this skill picks model or hybrid, to put real dollar and millisecond numbers on the chosen path.
- **`/problem-statement-doctor`** — clean up the feature framing before you spend cycles scoring architecture trade-offs against a fuzzy target.

## License

MIT. See repo root.
