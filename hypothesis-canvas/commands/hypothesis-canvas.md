---
description: Convert a fuzzy idea into a falsifiable A/B-ready hypothesis with a mandatory abandon-if clause.
argument-hint: "[rough idea or change description]"
---

Load the `hypothesis-canvas` skill and run its hypothesis-framing workflow.

PM input (may be empty — if so, ask for the rough idea first): $ARGUMENTS

Follow the skill exactly:
- Fill all 6 mandatory fields: change, metric, magnitude, segment, mechanism, abandon-if.
- If you cannot produce a concrete, numeric/observable `abandon-if`, REFUSE to render the artifacts and push the PM for one.
- Write `hypothesis.html`, `hypothesis.md`, and `hypothesis.json` to `hypothesis-canvas/canvases/<slug>/` relative to this repo root.
