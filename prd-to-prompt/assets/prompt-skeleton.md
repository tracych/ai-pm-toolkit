# System Prompt Skeleton

Every prompt produced by `prd-to-prompt` uses this exact structure. Do not invent sections; do not skip sections. If a section has nothing to say, write `_(none specified in PRD)_` — that absence is signal.

---

<!--
Version: v0.1
Date: <YYYY-MM-DD>
Author: <unixname or placeholder>
Source PRD: <one-line reference, or "pasted inline">
Change log:
- v0.1 — initial draft from PRD section.
-->

## ROLE

One paragraph. Who the assistant is, who it serves, and the single highest-level outcome it's responsible for. No tactics here.

> Example: *You are a meeting-summary assistant for a busy product manager. Your job is to turn raw meeting transcripts into short, faithful summaries the PM can scan in under 15 seconds.*

## CAPABILITIES

Bulleted list of verbs the assistant can perform. Keep it tight — capabilities not listed here are out of scope by default.

- <verb + object, e.g., "Summarize a meeting transcript into a fixed-shape bullet list">
- <verb + object>
- <verb + object>

## CONSTRAINTS

Bulleted must / must not rules, lifted directly from the PRD section. Each constraint should be phrased so a reader can imagine the failing case. Each constraint becomes an assertion in `assertions.md` — there should be 1-to-1 traceability.

- **MUST** <positive rule, e.g., "produce exactly 3 top-level bullets, no more and no less">
- **MUST NOT** <negative rule, e.g., "include any attendee name not present verbatim in the input transcript">
- **MUST** <e.g., "preserve action items by attributing each to the named owner, when an owner is named in the transcript">
- **MUST NOT** <e.g., "speculate about meeting outcomes that are not stated in the transcript">

## REFUSAL POLICY

Bulleted. Each item names a **trigger** AND the **exact response text** (or output schema for the refusal). "Don't hallucinate" is not a refusal policy — it has no trigger and no response.

- **Trigger:** <condition, e.g., "input transcript word count < 100">
  **Response (verbatim):** `<the exact string the assistant must emit>`
- **Trigger:** <condition>
  **Response (verbatim):** `<the exact string>`

If the PRD names a refusal condition without specifying the response text, write a candidate response in this section and flag it in `summary.md` under "PRD gaps" so the PM can confirm or correct it in v0.2.

## OUTPUT FORMAT

The literal shape of the output. Be specific about:

- **Structure** (markdown layout, JSON schema, plain text).
- **Length budget** (max words, max bullets, max characters).
- **Required fields** and their order.
- **Forbidden fields** (e.g., no preamble, no closing pleasantry, no chain-of-thought).

Example:

```
- <bullet 1: one sentence, ≤ 20 words>
- <bullet 2: one sentence, ≤ 20 words>
- <bullet 3: one sentence, ≤ 20 words>
```

## EXAMPLES

At least one **positive** example and at least one **negative** example. Negatives are annotated with the specific constraint they violate.

### Positive example

**Input (abridged):**
> <short input>

**Expected output:**
> <model output that satisfies all constraints>

### Negative example — what NOT to do

**Input (abridged):**
> <same or similar input>

**Bad output:**
> <output that violates a specific constraint>

**Why it's wrong:** Violates constraint "<quote the constraint>" — <one-line explanation of the failure mode>.
