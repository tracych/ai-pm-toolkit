---
description: Simulate 5 distinct failure futures for a launch — one per archetype — with causal chains and early-warning metrics.
argument-hint: "[feature or launch description, 12+ words]"
---

Load the `premortem` skill and run it against the brief below.

Launch brief (may be empty — if so, ask for one before doing anything else): $ARGUMENTS

Follow the skill exactly:
- Refuse to run if the brief is fewer than 12 words; ask the PM to expand on user, surface, and intended outcome.
- Always emit one story per archetype, in the canonical order: adoption-flop, trust-incident, abuse-vector, performance-regression, internal-politics.
- End with the summary table.
- Write the result to `premortem.md` in the current working directory.
