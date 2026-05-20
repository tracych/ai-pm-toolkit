---
description: For an LLM-powered feature, enumerate the top 7 hallucination/failure modes specific to its input/output shape, with detection strategies and user-facing mitigations.
argument-hint: "[feature description: input shape, output shape, consumer, blast radius]"
---

Load the `hallucination-profiler` skill and run its profiling workflow.

Feature description (may be empty — if so, ask the user for one): $ARGUMENTS

Follow the skill exactly:
- Refuse if the input is missing input shape, output shape, or who consumes the output.
- Pick the top 7 failure modes from the 12-item canonical taxonomy in `assets/failure-taxonomy.md`, ranked by severity × likelihood for this specific feature.
- Tie each chosen mode to the feature's actual input/output shape — no generic risk-register text.
- Give each mode a detection strategy AND a user-facing mitigation (copy + UX).
- End with a day-1 instrumentation list of exactly 3 metrics.
- Write the output to `hallucination-profile.md` in the current working directory.
