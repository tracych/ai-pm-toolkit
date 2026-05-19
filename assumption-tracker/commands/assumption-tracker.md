---
description: Extract assumptions from a PRD, plot on a load-bearing × testable 2×2, and produce a top-5 kill list with the cheapest validation experiment per assumption.
argument-hint: "[path to PRD markdown, or pasted doc text]"
---

Load the `assumption-tracker` skill and run its extraction → classification → ranking pipeline.

Input (either a file path or raw doc text — skill decides): $ARGUMENTS

Follow the skill exactly:
- If `$ARGUMENTS` is empty, ask the user for a doc path or pasted text before doing anything else.
- Derive a `<slug>` (kebab-case, 2-4 words) from the doc title; write outputs under `assumption-tracker/output/<slug>/`.
- If fewer than 3 assumptions can be extracted, skip the HTML and emit `assumptions.md` only.
- Never invent assumptions that aren't supported by the doc — quote or paraphrase the source line for each.
