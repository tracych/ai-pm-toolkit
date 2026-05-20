# Model Capability Map — geometry-tutor

## Idea

> An AI tutor that watches a student solve geometry problems on a tablet and gives them targeted feedback after each step. The student writes their work with a stylus (mix of diagrams and equations). The tutor should catch reasoning errors, suggest the next step without giving the answer away, and adapt to whether the student is stuck on the concept or just the algebra.

## Capability matrix

| # | Model family | Verdict | Reason |
|---|--------------|---------|--------|
| 1 | LLM-frontier | ENABLES | Explaining geometry reasoning step-by-step and generating Socratic next-step hints is well within current capability. |
| 2 | LLM-open | PARTIALLY-ENABLES | Mid-sized open models can do hint generation on common problem types but degrade on novel proofs; viable for cost-down once the prompt is stable. |
| 3 | vision-LLM | PARTIALLY-ENABLES | Can read clean stylus equations and recognize labeled diagrams, but messy handwriting and sketched geometric figures hit a recognition cliff. |
| 4 | speech | NOT-RELEVANT | Interaction is stylus + text; no voice in the core loop unless added later. |
| 5 | recsys/ranking | PARTIALLY-ENABLES | Useful for sequencing which problem to serve next based on the student's history, but not for the in-step feedback loop. |
| 6 | world-models | NOT-RELEVANT | No environmental simulation needed — geometry tutoring is a symbolic + visual task, not a dynamics-prediction task. |
| 7 | 3D-generative | NOT-RELEVANT | Problems are 2D; no asset generation in the loop. |
| 8 | agents-with-tools | ENABLES | A short tool-using loop (parse handwriting → check step against a symbolic geometry engine → generate hint) fits the 3–5-step sweet spot. |
| 9 | embeddings/retrieval | ENABLES | Retrieving similar past problems and known misconception patterns to ground the hint is a clean RAG fit. |
| 10 | classical-ML | ENABLES | A small calibrated model over student-history features can reliably classify "stuck on concept" vs. "stuck on algebra" once labeled data exists. |

## Capability cliffs

### Cliff 1: Handwritten-diagram understanding
- **What the idea needs:** Reliably parse a student's stylus-drawn geometric figure (triangle with labeled vertices, an inscribed circle, a tangent line) and link the drawing to the equations next to it.
- **Why it's a cliff:** As of the current model generation, vision-LLMs handle clean printed diagrams and labeled OCR well, but sketched hand-drawn figures with overlapping lines, informal labels, and mid-stroke corrections are unreliable. Precise spatial reasoning ("which segment is the student calling AB?") is a known weakness.
- **How close are we:** On the edge — fine-tuning on a domain-specific corpus of student diagrams would likely close most of the gap; pure zero-shot will not.

### Cliff 2: Diagnosing reasoning error vs. arithmetic slip
- **What the idea needs:** Distinguish "the student picked the wrong theorem" from "the student picked the right theorem and dropped a sign." The hint for each is different.
- **Why it's a cliff:** Frontier LLMs can grade a final answer reliably, but localizing the *first* error in a multi-step solution and classifying its *type* drifts when work is messy or steps are skipped. The model often flags the symptom step instead of the root-cause step.
- **How close are we:** On the edge — pairing the LLM with a symbolic geometry checker (deterministic) to localize the first invalid step, then asking the LLM only to classify and hint, is a viable workaround.

### Cliff 3: Hint quality without giving the answer
- **What the idea needs:** Generate a hint that nudges the student toward the next step without revealing it. The pedagogical bar is high — bad hints either give it away or are uselessly vague.
- **Why it's a cliff:** LLMs default to over-helpful, full-answer outputs. Constraining them to Socratic hints requires careful prompting and evaluation; "hint quality" is hard to measure automatically and easy to overfit to a rubric.
- **How close are we:** On the edge — achievable with prompt engineering plus a teacher-in-the-loop eval set, but quality will vary across topics until you have ~100s of graded hint examples per topic.

## Recommendation

**Primary:** agents-with-tools (frontier LLM + symbolic geometry checker + retrieval over a misconception bank) — gives you the best chance at reliable error localization and high-quality hints by combining the LLM's hint-writing with a deterministic checker for the "is this step valid?" question.

**Fallback:** LLM-frontier alone with carefully engineered prompts and a smaller pre-canned hint library per problem — ships sooner, costs less per session, and is good enough for common problem types, at the cost of weaker error-localization on novel problems and more "off-topic" hints.

## Resolver experiment

**Question:** Can a frontier vision-LLM, given a photo of a student's handwritten geometry work, reliably (≥ 80% of cases) identify the *first* step where the reasoning goes wrong on a representative set of 30 problems?

**Setup:** Collect 30 real (or recruited) examples of student work on intro geometry problems — a mix of correct, arithmetic-error, and conceptual-error solutions. One PM + one engineer hand-label the ground-truth "first invalid step" for each. Prompt the vision-LLM with the image and ask it to identify the first invalid step and classify the error type. Compare to the labels. Optionally run a second arm where the LLM is paired with a symbolic geometry checker (e.g., a small Python proof checker over parsed equations) to see if the combined system closes the gap.

**Pass:** The LLM alone, or LLM + checker, correctly identifies the first invalid step in ≥ 24 of 30 cases, with error-type classification matching the human label.

**Fail:** Either approach lands materially below that bar, or the failure modes are non-systematic (no clear "fine-tune the vision part" or "add a checker" fix).

**Why this resolves the cliff:** Cliff 2 (error localization) is the highest-risk dependency — if the system can't tell *where* the student went wrong, every downstream hint is worse than useless. A 5-day labeling + prompting spike will tell you whether the architecture is viable before you commit to a quarter of build.

## Notes

- Handwriting recognition quality (Cliff 1) was scoped out of the resolver experiment to keep it under a week; assume clean typed input for the test and run a separate spike on diagram OCR before committing to a stylus-first UX.
- The recsys/ranking row is real but not in the critical path for v1 — defer until there's enough student-session data to train on.
- "Adapt to the student" was not scored as a separate cliff because it depends on personalization data the product won't have at launch; revisit after 3 months of usage.
