---
description: Guide a PM from problem → JTBD → flow → design → self-contained HTML prototype, gated phase-by-phase.
argument-hint: "[optional one-line problem brief]"
---

Load the `protopilot` skill and run its 4-phase workflow.

User brief (may be empty — if so, start with Phase 0 intake): $ARGUMENTS

Follow the skill exactly:
- Gate on explicit user approval between each phase.
- Do not skip Phase 1 (JTBD) even if the brief looks like a feature request — derive the job first.
- Output to `protopilot/prototypes/<slug>/prototype.html` relative to this repo root.
