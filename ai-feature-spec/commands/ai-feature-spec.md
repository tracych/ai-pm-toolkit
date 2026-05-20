---
description: Turn a PM brief for an AI feature into an engineer-ready spec with 9 mandatory sections (I/O contract, model contract, failure modes, fallback, eval seed, telemetry, open questions).
argument-hint: "[your AI feature brief]"
---

Load the `ai-feature-spec` skill and run its spec-generation workflow.

PM brief (may be empty — if so, ask the user to paste one): $ARGUMENTS

Follow the skill exactly:
- If the brief is missing the user job OR a concrete input example, refuse to render and ask for both.
- Produce all 9 sections in order using the canonical template at `assets/spec-template.md`.
- Use `[bracketed placeholders]` for any number not in the brief and re-list each one in Open questions.
- Write the output to `ai-feature-spec.md` in the current working directory.
