---
description: "Pre-meeting briefing: draft answers to the 12 questions engineers will ask, with H/M/L confidence flags and owners for every unknown."
argument-hint: "<feature description, or path to a spec doc>"
---

Load the `scoping-primer` skill and produce the pre-scoping briefing.

Input (feature description or path to spec): $ARGUMENTS

Follow the skill exactly:
- Refuse to run if the feature description (or doc content) is fewer than 15 words — ask the user for more detail first.
- Load the canonical 12 questions from `scoping-primer/assets/engineer_questions.md` and answer them in order.
- Flag every row H / M / L; name an owner for every L.
- End the file with a "Before the meeting, get answers for:" checklist of every L row.
- Write the result to `scoping-primer.md` in the current working directory.
