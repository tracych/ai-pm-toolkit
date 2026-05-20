---
name: eval-set-curator
description: |
  Expansion skill that turns 3–10 happy-path seed examples for an LLM/AI feature into a balanced 50-row eval set covering 10 canonical edge-case categories (empty, long, multilingual, hostile, ambiguous, format-violating, out-of-scope, edge-of-domain, implicit-assumption, regression-from-prior-bug). Each generated row carries an explicit expected behavior and a concrete, machine-checkable pass criterion (regex, keyword match, or short LLM-judge rubric). Outputs JSONL for tooling, an HTML viewer for browsing/marking pass-fail, and a markdown summary. Use when the user wants to: bootstrap an eval set from a few good examples, expand coverage of an existing AI feature into edge cases, generate a balanced test set before launch, or stress-test an LLM prompt against the categories teams most often under-cover.

  Do NOT trigger for: discovering failure modes from production logs (use hallucination-profiler), writing the prompt itself (use prd-to-prompt), generating hostile prompts only (use ai-redteam-prompts), or building the feature spec from scratch (use ai-feature-spec).
---

# eval-set-curator (skill)

Expand a handful of working examples into a balanced eval set the team will actually run. Five rows per category, ten categories, fifty rows. Every row checkable.

## Operating principles

- **Balanced coverage is non-negotiable.** Five rows per category, exactly 50. Do not over-index on the categories that are easy to generate (empty, long) at the expense of the ones teams under-test (hostile, out-of-scope).
- **Concrete pass criteria.** "Refuses politely" is not a pass criterion. "Output contains the literal string `I can't help with that`" is. Prefer regex / keyword over LLM-judge; use LLM-judge only when the behavior is genuinely subjective.
- **Hostile and out-of-scope are mandatory.** The skill will not skip them even if the user is uncomfortable — teams ship broken AI features specifically because these categories were under-tested.
- **LLM-judge rubrics stay short.** Under 5 lines, binary pass criterion. Long rubrics are noisy and rarely re-run.
- **No fabricated regressions.** The regression-from-prior-bug category requires user-supplied known failures. If the user gives none, leave that category empty (0 rows, not 5) and flag it in the summary. Do not invent bugs.

## Inputs

- A feature description (1–3 sentences explaining what the LLM feature does) plus 3–10 seed examples, each with `input` and `expected_output`. Passed as `$ARGUMENTS` or pasted into the conversation.
- Optional: known prior bugs (input + what went wrong), to seed category 10.

If the user provides fewer than 3 seed examples, respond with a single ask:

> "I need at least 3 seed examples to extract a pattern worth expanding. For each, paste: (1) an input that works today, (2) the expected output. Optional: any known prior bugs (input + what went wrong) for the regression category."

Do not proceed until the user provides them.

## Step 1 — Load the categories reference

Read `assets/categories.md` (relative to this skill). It defines all 10 canonical edge-case categories with a definition, "when to generate", and "when to skip" for each. Use those definitions verbatim — do not invent your own categories or merge them.

## Step 2 — Extract the seed pattern

From the seed examples, distill:

- **Input shape** — what fields, format, length, language do the working examples share?
- **Expected output shape** — structured vs. prose, length, required fields, tone.
- **Implicit guardrails** — what is the feature *not* meant to do? (Even if the user didn't say so explicitly, infer from the examples.)

Write a 3–5 line `feature_profile` to the top of the markdown summary. This is what every generated row will be tested against.

## Step 3 — Generate 5 rows per category

For each of the 10 categories in `assets/categories.md`, generate exactly 5 rows. Each row is a JSON object with these fields:

```json
{
  "id": "cat03-r02",
  "category": "multilingual",
  "input": "<the test input>",
  "expected_behavior": "<concrete, observable description>",
  "pass_criteria": {
    "type": "regex" | "keyword" | "schema" | "llm_judge",
    "value": "<the regex / keyword / schema / rubric>"
  },
  "seed_ref": "seed-2",
  "notes": "<one line on why this row matters>"
}
```

Rules:

- `expected_behavior` must be specific. "Outputs in the same language as the input (Spanish)" — not "handles other languages".
- `pass_criteria.type` priority: `regex` > `keyword` > `schema` > `llm_judge`. Only use `llm_judge` when behavior is genuinely subjective; the rubric value must be ≤ 5 lines and end with a binary "PASS if … else FAIL" clause.
- `seed_ref` ties the row back to the seed example it was derived from, so the PM can audit the expansion.
- Across the 5 rows in a category, vary the *axis of stress* — for "long", include one slightly-over-limit, one extreme, one with the signal buried mid-input, one with redundant repetition, one with the signal at the very end.

For category 10 (regression-from-prior-bug):

- If the user provided ≥ 1 known bug, generate up to 5 rows (one per bug, plus close variants if fewer than 5 bugs supplied — but never more than 2 variants per bug).
- If the user provided 0 bugs, leave the category empty (0 rows in JSONL, flagged in markdown).

## Step 4 — Write the JSONL

Write `eval-set-curator/sets/<slug>/eval-set.jsonl` where `<slug>` is a short kebab-case slug derived from the feature description (e.g., `action-item-extractor`, `support-triage-classifier`).

One row per line. No surrounding array. Field order as in Step 3.

If category 10 is empty, the file has 45 lines; otherwise 50.

## Step 5 — Write the HTML viewer

Read `assets/viewer_template.html`. Inline the JSONL contents into the placeholder `__EVAL_SET_JSONL__` (as a JSON string — escape backticks and `</script>`).

Write to `eval-set-curator/sets/<slug>/eval-set.html`. The viewer must work offline by double-clicking the file.

Features the template provides:

- Filter by category (sidebar)
- Mark each row PASS / FAIL / SKIP, persisted to localStorage keyed by row `id`
- Counter at the top: `X / 50 marked` and `Y PASS, Z FAIL, W SKIP`
- Export marked results to a JSON blob the team can paste into a tracker

## Step 6 — Write the markdown summary

Write `eval-set-curator/sets/<slug>/eval-set.md` with:

```
# Eval set — <feature name>

## Feature profile
<3–5 line profile from Step 2>

## Coverage
| # | Category | Rows | Pass-criteria types |
|---|----------|------|---------------------|
| 1 | empty | 5 | regex × 3, keyword × 2 |
| ... |
| 10 | regression-from-prior-bug | 0 (no user-supplied bugs — see notes) |

**Total: 45 / 50** (or 50 / 50 if cat 10 was filled)

## Sample rows (one per category)
<for each non-empty category, render the first row as a markdown block: input, expected behavior, pass criteria>

## Notes
- <flag missing regression bugs if applicable>
- <flag any seed that didn't expand cleanly>
- <flag any category where LLM-judge was needed for > 2 of 5 rows — usually means expected behavior wasn't sharp enough>
```

## Step 7 — Report back

After writing, report:

1. Absolute paths to the three output files.
2. Total row count (45 or 50) and which categories — if any — were left empty or under-filled, with the reason.
3. The single recommended next action: e.g., "Run this set against your current prompt with `/prd-to-prompt`'s assertions block — failures here are launch blockers."

## How this skill differs from adjacent skills

- **`hallucination-profiler`** — discovers *new* failure modes from production behavior or red-team probing. eval-set-curator codifies known categories into a reusable set. Use profiler to find what's broken; use curator to make sure it stays fixed.
- **`prd-to-prompt`** — generates the prompt and its assertions. eval-set-curator generates the inputs that test the prompt. They are inverse skills.
- **`ai-redteam-prompts`** — produces adversarial inputs for one category (hostile). eval-set-curator produces a balanced set across all 10 categories. Fold redteam outputs into the hostile category here.
- **`ai-feature-spec`** — defines what the feature is and what good looks like (with a small seed set). eval-set-curator takes that seed set and expands it for evaluation.
