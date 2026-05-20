---
description: Turn a PRD section describing LLM behavior into a versioned system prompt, testable assertions, and a 5-row eval seed.
argument-hint: "[PRD section describing the desired LLM behavior]"
---

Load the `prd-to-prompt` skill and run its prompt + assertions + eval-seed workflow.

PRD section (may be empty — if so, ask the user to paste one): $ARGUMENTS

Follow the skill exactly:
- If the PRD section is missing at least one constraint OR at least one refusal condition, refuse and ask for both.
- Produce a versioned system prompt using the 6-section skeleton in `assets/prompt-skeleton.md`.
- Extract testable assertions 1-to-1 from the PRD's constraints and refusal conditions.
- Produce a 5-row eval seed where every assertion is exercised by at least one row.
- Write all four files to `prd-to-prompt/prompts/<slug>/` in the current working directory.
