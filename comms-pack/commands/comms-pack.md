---
description: From one launch brief, fan out 6 audience-tuned comms artifacts plus a single-file HTML preview.
argument-hint: "[optional audience filter list] <launch brief paragraph>"
---

Load the `comms-pack` skill and run it.

User input (may include an optional `[audience1,audience2,...]` filter prefix, then the launch brief): $ARGUMENTS

Follow the skill exactly:
- Refuse if the brief is fewer than 20 words.
- Derive a `<slug>` (kebab-case, 2-4 words) from the brief and write to `comms-pack/<slug>/`.
- Generate each requested audience artifact using the template in `assets/audience_templates.md`.
- Run the "can't defend this claim" pass on `exec-update.md` and `customer-email.md`; mark gaps inline with `[NEEDS EVIDENCE: ...]`.
- Render the `index.html` preview from `assets/preview_template.html` by replacing each `<!-- SLOT:<name> -->` marker with the corresponding artifact content.
