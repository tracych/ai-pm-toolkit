---
description: For a proposed AI feature, score a 5×3 matrix (cost / latency / explainability / maintainability / failure-recovery × model / rules / hybrid) and pick an approach, with a rules-first MVP option.
argument-hint: "[describe the feature in 15+ words: who, what, how often, what happens if wrong]"
---

Load the `model-vs-rules-matrix` skill and run its triage + matrix + recommendation workflow.

Feature description (may be empty — if so, ask the user to paste one): $ARGUMENTS

Follow the skill exactly:
- If the input is fewer than 15 words, refuse to score and ask for a fuller description.
- Score all 15 cells of the 5×3 matrix using the anchors in `assets/dimensions.md`.
- Produce a recommendation, two "switch-your-answer-if" triggers, and a rules-first MVP.
- Flag loudly any pure-model recommendation for high-stakes (money / safety / moderation) features.
- Write the output to `model-vs-rules.md` in the current working directory.
