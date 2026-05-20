---
description: Generate 20 adversarial test prompts targeted at an AI feature's failure surface, ranked by severity x likelihood, with a top-5 fix-before-launch list.
argument-hint: "[describe the AI feature: input shape, output consumer, blast radius]"
---

Load the `ai-redteam-prompts` skill and run its red-team generation workflow.

Feature description (may be empty — if so, ask the user for one): $ARGUMENTS

Follow the skill exactly:
- If the user has not stated **who consumes the output** (chatbot user, agent tool, downstream pipeline, human reviewer), refuse and ask — severity cannot be scored without blast radius.
- Generate exactly 20 prompts spanning the 8 canonical attack categories (at least 2 prompts each for categories 1, 2, 3).
- Score severity (1–5) anchored to the stated blast radius, and likelihood (1–5) anchored to typical attacker behavior.
- Write the output to `redteam-prompts.md` in the current working directory, including the top-5 fix-before-launch list and the blind-spot disclaimer.
