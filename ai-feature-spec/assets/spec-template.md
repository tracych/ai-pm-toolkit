# AI Feature Spec — <feature name>

> Canonical 9-section template. Render every section, in order, even if the brief is thin — gaps become `[bracketed placeholders]` plus rows in Section 9.

## 1. Feature description + user job

One paragraph in plain language. Name the feature, then state the user job in the user's terms.

- **Feature:** <one sentence describing what the feature does in the product>
- **User job:** <"When I'm doing X, I want to Y so I can Z."> — phrased from the user's perspective, not the company's.
- **Where it lives in the product:** <surface, entry point, trigger>
- **Out of scope:** <one or two things this feature is explicitly NOT doing — prevents scope drift>

## 2. Inputs

Exact shape of what gets passed to the model on each call.

**Schema:**

```
{
  "<field_name>": "<type>",     // <one-line description>
  ...
}
```

**Example value (real, not a placeholder):**

```
{
  "<field_name>": "<actual example value the model would see in production>",
  ...
}
```

**Max sizes:**

| Field | Max size | Unit | If exceeded |
|-------|----------|------|-------------|
| <field_name> | `[?]` | tokens / chars / bytes / items | <truncate / reject / chunk> |

If max sizes aren't in the brief, use `[?]` and add a row in Section 9.

## 3. Outputs

Exact shape of what the model returns.

**Schema:**

```
{
  "<field_name>": "<type>",     // <one-line description>
  ...
}
```

**Example value (fully populated, not `<placeholder>`):**

```
{
  "<field_name>": "<actual example output a user would see>",
  ...
}
```

**Format validation rules:**

- <rule 1 — e.g., "summary field is 1–3 sentences, max 400 chars">
- <rule 2 — e.g., "must not contain markdown headers">
- <rule 3 — e.g., "must reference only entities present in the input">

If the output is free text, name the validation rules anyway (max length, required structure, forbidden content).

## 4. Model contract

| Field | Value | Notes |
|-------|-------|-------|
| Model family | <e.g., "frontier LLM, text-only"> | <capability needed vs. cheaper alternative> |
| Tier | <e.g., "mid-tier — Sonnet-class or equivalent"> | <why this tier and not cheaper / pricier> |
| Expected p95 latency | `[?]` ms | <user-perceived budget — feeds `/cost-latency-budgeter`> |
| Expected cost per call | `[?]` | <currency + unit, e.g., USD per call> |

Add one line on **why this tier:** <what capability would break if you dropped a tier — JSON adherence, multi-step reasoning, long-context recall, etc.>

## 5. Failure modes

Top 5 ways this can go wrong. If the input shape matches a known taxonomy (grounded summarization, structured extraction, agentic tool use), draw failure modes from it.

| # | Failure mode | Why it happens | Detection signal |
|---|--------------|----------------|------------------|
| 1 | <e.g., hallucinated number not in input> | <e.g., model fills in plausible-looking but invented values> | <e.g., post-hoc check: every number in output must appear in input> |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |

> Run `/hallucination-profiler` against this feature to deepen this section into a full taxonomy.

## 6. Fallback policy

What the user actually sees when the model fails, times out, or returns low-confidence output. Be specific — "graceful fallback" is not a policy.

| Failure case | What the user sees | What gets logged |
|--------------|-------------------|------------------|
| Model error (5xx, malformed output, validation failure) | <specific UI behavior, e.g., "show raw input with 'unavailable — retry' link"> | <error code, input hash, model version> |
| Timeout (> p95 budget) | <specific UI behavior> | <timeout flag, latency, input hash> |
| Low-confidence output (failed validation, refusal, off-topic) | <specific UI behavior> | <confidence signal, input hash, raw output> |

## 7. Eval seed

Five concrete I/O pairs. This is the *seed* — `/eval-set-curator` scales it later. Five rows is enough to stop arguments and start arguing about the right things.

| # | Input | Expected output (shape or content) | Pass criteria |
|---|-------|-------------------------------------|---------------|
| 1 | <real input> | <real expected output> | <one sentence: what makes this row pass> |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |

**Rubric (1 paragraph):** How should a human reviewer grade ambiguous cases? Name the dimensions that matter (faithfulness to input, brevity, tone, format adherence, etc.) and the trade-offs between them. This is the rubric a labeler will internalize before they ever look at row 6.

## 8. Telemetry

Per-call log schema. If any of these can't be logged, the team can't iterate — flag in Section 9.

| Field | Type | Notes |
|-------|------|-------|
| `input_hash` | string | SHA of canonicalized input; not raw input (PII). |
| `model_version` | string | Includes prompt version, not just model ID. |
| `prompt_version` | string | Version of the system prompt / template. |
| `latency_ms` | int | Wall-clock from request to response. |
| `output` | string | Raw output OR `output_hash + output_length` if PII risk. |
| `user_action` | enum | One of: `clicked`, `dismissed`, `copied`, `regenerated`, `reported`, `none`. |
| <feature-specific> | | <e.g., chart_type, document_length, user_segment> |

## 9. Open questions

Every `[bracketed placeholder]` above appears here as a question with an owner tag. Every judgment call the spec made appears here too.

- [ ] <question 1> `[OWNER: ?]`
- [ ] <question 2> `[OWNER: ?]`
- [ ] <question 3> `[OWNER: ?]`

This section is the receipts for what the brief did not specify. Do not leave it blank — a spec with zero open questions is either lying or done.
