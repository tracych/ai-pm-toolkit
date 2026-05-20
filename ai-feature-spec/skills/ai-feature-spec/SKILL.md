---
name: ai-feature-spec
description: |
  Generation skill that turns a PM brief for an AI-powered feature into an engineer-ready spec with 9 mandatory sections: (1) feature description + user job, (2) inputs with schema/examples/max sizes, (3) outputs with schema/examples/validation, (4) model contract (family, tier, p95 latency target, cost per call target), (5) top-5 failure modes with detection signals, (6) fallback policy (what the user sees on failure/timeout/low-confidence), (7) eval seed (5 I/O pairs + per-row pass criteria + 1-paragraph rubric), (8) per-call telemetry schema, (9) open questions with owner placeholders. Use when the user wants to: write the build doc for an AI feature, hand off a model-powered feature to engineering, pressure-test whether a brief is actually buildable, or generate a spec scaffold a team can fill in.

  Do NOT trigger for: non-AI feature specs (use a normal PRD template), upstream problem framing (use problem-statement-doctor first), exploratory research on whether to build the feature (use pm-deep-dive), expanding an existing eval set beyond the 5-row seed (use eval-set-curator), or turning the spec into a system prompt (use prd-to-prompt).
---

# ai-feature-spec (skill)

Turn a PM brief for an AI feature into an engineer-ready spec. Nine sections, no skipping, no inventing numbers.

## Operating principles

- **All 9 sections are mandatory.** A spec without a fallback policy is a spec for a demo. A spec without telemetry is a spec for a one-shot. Render every section, even if it's mostly placeholders + open questions.
- **Concrete examples in every I/O section.** Every input field gets at least one real example value. Every output schema gets at least one fully populated example. Schemas without examples ship as bugs.
- **Refuse to invent metrics.** If the brief lacks latency targets, cost ceilings, traffic estimates, or accuracy thresholds, use `[bracketed placeholders]` and add a matching row in Open questions. Never make up a p95 number to fill a gap.
- **The eval seed is 5 rows, not 50.** This is the seed. Volume comes later via `/eval-set-curator`. Five rows is enough to stop arguments and start arguing about the right things.
- **Telemetry is per-call and non-negotiable.** Input hash, model version, latency, output, user action on output. If the brief can't support all four, call it out in Open questions — that gap blocks iteration.

## Inputs

- A PM brief for an AI feature, passed as `$ARGUMENTS` or pasted into the conversation.

The brief must contain, at minimum:
1. **A user job** — what the user is trying to accomplish (not "we want to add AI", but "user clicks chart and gets a summary").
2. **At least one concrete input example** — a real example of what goes into the model (the chart, the document, the message thread).

If either is missing, respond with a single ask:

> "I need two things before I can spec this:
> (1) the user job in user terms — what is the user doing and why?
> (2) one concrete input example — a real instance of what gets passed to the model.
> Paste both and I'll render the full 9-section spec."

Do not proceed until the user provides both.

## Step 1 — Load the template

Read `assets/spec-template.md` (relative to this skill). It defines the canonical 9-section structure with placeholder prose. Use that structure exactly — do not reorder, merge, or drop sections.

## Step 2 — Extract what the brief actually says

Before drafting, list what the brief explicitly provides for each section. Anything not in the brief becomes a `[bracketed placeholder]` in the spec body and a row in Open questions. Do not silently fill gaps with assumptions.

Specifically, scan for:
- User job (Section 1) — should be present, you refused above if not.
- Input shape and at least one example (Section 2) — should be present, you refused above if not.
- Output shape, format constraints (Section 3).
- Model preference, latency target, cost ceiling, traffic estimate (Section 4).
- Known failure modes the PM is worried about (Section 5).
- Fallback expectations — what does the user see when it breaks? (Section 6).
- Examples of good / bad outputs (Section 7).
- Logging or analytics requirements (Section 8).

## Step 3 — Render all 9 sections

Fill the template top to bottom. Section-specific rules:

**Section 1 — Feature description + user job.** One paragraph. State the feature in plain language and name the user job in the user's terms ("user clicks chart and wants to understand it in 10 seconds", not "we want to add chart summaries").

**Section 2 — Inputs.** A schema block (JSON, table, or typed pseudocode) plus at least one concrete example value per field plus max sizes (token count, character count, byte size, list length — whichever applies). If max sizes aren't in the brief, use `[max: ?]` and flag in Open questions.

**Section 3 — Outputs.** Same treatment: schema + at least one fully populated example + format validation rules (regex, JSON schema, required fields, length bounds). If the output is free text, name the validation rules anyway (max length, required structure, forbidden content).

**Section 4 — Model contract.** Four sub-fields: model family (e.g., "frontier LLM, text-only"), tier (e.g., "mid-tier — Sonnet-class or equivalent"), expected p95 latency, expected cost per call. Use `[bracketed placeholders]` for any number the brief doesn't provide. Add a one-line note on why this tier (capability needed vs. cheaper alternative).

**Section 5 — Failure modes.** A 5-row table. Each row: failure mode (e.g., "hallucinated number not present in input"), why it happens (one phrase), detection signal (what would catch it — assertion, post-hoc check, user thumbs-down, etc.). If the input shape is well-suited to a known taxonomy (e.g., grounded summarization → hallucination taxonomy), draw from that. Note where `/hallucination-profiler` would deepen this section.

**Section 6 — Fallback policy.** Three rows: failure case (model error, timeout, low-confidence output), what the user sees, what gets logged. The user-visible behavior must be specific ("show the raw chart with a 'summary unavailable — retry' link", not "graceful fallback").

**Section 7 — Eval seed.** Exactly 5 rows. Each row: input (concrete, not a placeholder), expected output shape/content, pass criteria (one sentence: what makes this row pass). Below the table, one paragraph rubric describing how a human reviewer should grade ambiguous cases. Five rows, not three, not ten — five.

**Section 8 — Telemetry.** A per-call log schema. Must include at minimum: input hash (not raw input, for PII), model version + prompt version, latency (ms), output (or output hash + length), user action on output (clicked / dismissed / copied / regenerated / none). Plus any feature-specific fields from the brief.

**Section 9 — Open questions.** Bulleted list. Every `[bracketed placeholder]` in the spec body must appear here with a question and an `[OWNER: ?]` tag. Add any judgment calls the spec made (e.g., "assumed English-only — confirm with PM"). This section is the receipts for what the brief did not specify.

## Step 4 — Write the output

Write everything to `ai-feature-spec.md` in the current working directory. Use the exact section headers from the template so downstream skills (`/eval-set-curator`, `/prd-to-prompt`) can parse it.

After writing, report:

1. Absolute path to `ai-feature-spec.md`.
2. Count of `[bracketed placeholders]` in the spec body and matching count in Open questions (these should match).
3. Which adjacent skill would tighten the weakest section (e.g., "Failure modes is thin — run `/hallucination-profiler` next; Model contract has 3 placeholders — run `/cost-latency-budgeter` next").

## Output format spec

The output file must be valid markdown with exactly these top-level headers, in this order:

```
# AI Feature Spec — <feature name>
## 1. Feature description + user job
## 2. Inputs
## 3. Outputs
## 4. Model contract
## 5. Failure modes
## 6. Fallback policy
## 7. Eval seed
## 8. Telemetry
## 9. Open questions
```

Downstream skills key off these exact headers. Do not rename them.

## How this skill differs from adjacent skills

- **`problem-statement-doctor`** — sharpens the *upstream* problem framing. ai-feature-spec assumes the problem is already framed and turns the solution brief into a build doc.
- **`pm-deep-dive`** — investigates whether the feature is worth building. ai-feature-spec assumes the build decision is made and produces the spec.
- **`/hallucination-profiler`** — deepens Section 5 with a full taxonomy. ai-feature-spec produces a top-5 starter list; profiler expands it.
- **`/cost-latency-budgeter`** — produces the actual p95 / cost numbers for Section 4. ai-feature-spec leaves placeholders; budgeter fills them.
- **`/eval-set-curator`** — turns the 5-row eval seed into a 50-row harness. ai-feature-spec writes the seed; curator scales it.
- **`/prd-to-prompt`** — turns the I/O schema and eval seed into a tested system prompt with assertions. ai-feature-spec writes the contract; prd-to-prompt implements it.
- **Generic "write a PRD" prompts** — produce free-form prose with no enforced structure. This skill produces 9 named sections downstream tools can parse.
