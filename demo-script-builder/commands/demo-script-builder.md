---
description: Generate a 5-minute audience-tuned demo script with stage directions, wow moment, and 3 pre-rebutted questions.
argument-hint: "<feature> --audience exec|customer|engineer"
---

Load the `demo-script-builder` skill and run it.

User input (feature description plus required `--audience` flag): $ARGUMENTS

Follow the skill exactly:
- If the `--audience` flag is missing or not one of `exec` / `customer` / `engineer`, ask the user before generating anything. Do not invent a fourth audience.
- Load the matching profile from `demo-script-builder/assets/audience_profiles.md` and use its framing rules and objection types verbatim.
- Write a single `demo-<audience>.md` to the current working directory with: 30-second elevator at top, 5-minute script with stage directions, `## WOW MOMENT` section, and Q&A appendix of 3 pre-rebutted questions.
