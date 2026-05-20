---
description: Audit a working AI demo against 10 readiness dimensions and triage must-fix vs ship-with-known-gap before launch.
argument-hint: "[describe the demo: what it does, what model/infra, current state, target launch surface]"
---

Load the `demo-to-product-gap-auditor` skill and run its 10-dimension audit workflow.

Demo description (may be empty — if so, ask the user for the 4 required inputs): $ARGUMENTS

Follow the skill exactly:
- If any of the 4 required inputs are missing (what it does, model/infra, current state, target launch surface + audience), ask for them before scoring.
- Score all 10 dimensions 1–5 using the anchors in `assets/audit-dimensions.md`.
- For each dimension: name the single biggest concrete gap and propose the minimum fix to reach a 4.
- If 3+ dimensions score 1–2, refuse "ready to ship" framing and emit a "still a demo" report.
- Write the three output files (`audit.html`, `audit.md`, `audit.json`) into `demo-to-product-audit/<slug>/`.
