---
description: Adversarial pre-mortem — generate the 7 strongest reasons an idea will fail, ranked, each with the cheapest falsification test.
argument-hint: "<one to three sentences describing the product idea>"
---

Load the `idea-killer` skill and run its full adversarial pre-mortem.

Idea to kill: $ARGUMENTS

Follow the skill exactly:
- If the idea is fewer than 10 words, refuse and ask the user to elaborate — do not write the report.
- Cover all 7 mandatory categories (demand, distribution, competition, regulation, unit economics, organization/team, timing). No skipping.
- Each failure mode must include a falsification test the PM can run in under a week.
- Rank by likelihood × consequence, worst first.
- End with the explicit "if all 7 are addressed, would you fund it?" gate.
- Write to `idea-killer/reports/<slug>/kill-report.md`.
- Do not bright-side. Do not hedge. The job is to kill it.
