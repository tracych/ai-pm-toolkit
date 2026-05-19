---
description: Score a draft problem statement on 8 rubrics and rewrite it at three specificity levels (broad / focused / surgical).
argument-hint: "[your draft problem statement]"
---

Load the `problem-statement-doctor` skill and run its diagnostic + rewrite workflow.

Draft problem statement (may be empty — if so, ask the user to paste one): $ARGUMENTS

Follow the skill exactly:
- If the input is fewer than 10 words, refuse to score and ask for more context.
- Score all 8 rubrics with a 1-sentence rationale each.
- Produce three rewrites at distinct specificity levels with trade-off annotations.
- Write the output to `problem-statement.md` in the current working directory.
