---
description: Expand 3+ seed examples for an LLM feature into a balanced 50-row eval set across 10 canonical edge-case categories, with expected behavior and pass criteria per row.
argument-hint: "[feature description + seed input/expected pairs, or leave empty to be prompted]"
---

Load the `eval-set-curator` skill and run its seed-expansion workflow.

Seed material (may be empty — if so, ask the user to paste a feature description plus at least 3 input/expected pairs): $ARGUMENTS

Follow the skill exactly:
- If fewer than 3 seed examples are provided, refuse and ask for more context.
- Generate exactly 5 rows per category × 10 categories = 50 rows, unless the regression-from-prior-bug category has no user-supplied bugs (in which case leave it empty and flag).
- Every row must have a concrete, machine-checkable pass criterion.
- Write `eval-set.jsonl`, `eval-set.html`, and `eval-set.md` into `eval-set-curator/sets/<slug>/` in the current working directory.
