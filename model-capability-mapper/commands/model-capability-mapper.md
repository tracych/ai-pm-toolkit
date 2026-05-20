---
description: Map a product idea onto the 10 AI model families, mark capability cliffs, and recommend a primary model family + fallback + a < 1-week resolver experiment.
argument-hint: "[your 1-paragraph product idea]"
---

Load the `model-capability-mapper` skill and run its triage workflow.

Product idea (may be empty — if so, ask the user to paste one): $ARGUMENTS

Follow the skill exactly:
- If the input is fewer than 15 words, refuse to map and ask for a fuller paragraph.
- Mark all 10 model families (ENABLES / PARTIALLY-ENABLES / CANNOT-YET / NOT-RELEVANT) with a one-line reason each.
- Identify the 3 hardest capability cliffs the idea sits near.
- Recommend one primary family + one fallback + one < 1-week resolver experiment.
- Write the output to `model-capability-map.md` in the current working directory.
