---
description: Walk a PM through an 8-question intake and produce a rollback plan + a checkable HTML checklist with numeric trigger thresholds and pre-filled comms templates.
argument-hint: "[launch or feature description]"
---

Load the `rollback-planner` skill and run its 8-question intake workflow.

Launch description (may be empty — if so, start by asking question 1): $ARGUMENTS

Follow the skill exactly:
- Walk the 8 questions in order. For each, draft your best initial answer from context, then ask the user to confirm or edit.
- Refuse vague answers on question 6 (metric thresholds) — force a number on each of the three triggers.
- Owners (question 4) must be role placeholders, never real names.
- Output to `rollback-planner/plans/<slug>/rollback-plan.md` and `rollback-planner/plans/<slug>/rollback-checklist.html` relative to this repo root.
