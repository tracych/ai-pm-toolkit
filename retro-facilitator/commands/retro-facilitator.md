---
description: "Walk a PM through a fixed 5-step post-launch retro and append the result to a local rolling archive."
argument-hint: "<launch-slug> [week-1|month-1]"
---

Load the `retro-facilitator` skill and run its 5-step agenda.

User input (launch slug + optional week-1/month-1 marker): $ARGUMENTS

Follow the skill exactly:
- Walk the 5 agenda steps in order, gating on explicit user approval between each.
- Do NOT finalize step 5 if any action item is missing an owner placeholder or a due date.
- Write the writeup to `retros/retro-<YYYY-MM-DD>-<slug>.md` (use `date +%Y-%m-%d`).
- Append a new row to `retros/index.html`; create it from `assets/archive_template.html` if it doesn't exist yet.
