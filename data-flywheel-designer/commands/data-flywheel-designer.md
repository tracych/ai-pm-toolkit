---
description: Design the 6-stage data flywheel for an AI feature — cold-start, signal capture, labeling, storage, retraining trigger, safe re-deploy.
argument-hint: "[AI feature description: model type + user interaction shape]"
---

Load the `data-flywheel-designer` skill and run its design workflow.

AI feature description (may be empty — if so, ask the user for model type + user interaction shape): $ARGUMENTS

Follow the skill exactly:
- If the input doesn't name both a model/task type and the user-interaction shape, refuse and ask for both.
- Design all 6 flywheel stages — every stage gets a concrete plan AND a "what goes wrong if you skip this" failure mode.
- Quantify the retraining trigger and labeling cost — placeholder numbers are fine, but they must be numbers.
- Write `data-flywheel.md` and `flywheel.html` (single-file, no CDN) to the current working directory.
