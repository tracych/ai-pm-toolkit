# AI Feature Spec — Explain This Chart

> Worked example output for the brief: "In-product 'explain this chart' button for a BI tool — user clicks chart, gets a 2-paragraph natural-language summary."

## 1. Feature description + user job

A button labeled "Explain this chart" appears in the toolbar of every rendered chart in the BI tool. On click, the user sees a 2-paragraph natural-language summary of what the chart shows, including the main trend, any notable outliers, and the headline number.

- **Feature:** A one-click "Explain this chart" button that returns a 2-paragraph plain-English summary of the chart the user is looking at.
- **User job:** "When I'm scanning a dashboard someone else built, I want to understand what each chart is telling me in 10 seconds, without having to decode the axes, so I can decide whether it matters and move on or dig in."
- **Where it lives in the product:** Chart toolbar, next to the export and share buttons. Available on all chart types in the standard renderer.
- **Out of scope:** Answering follow-up questions, modifying the chart, generating new charts, comparing across charts, anything multi-chart or dashboard-level. This is single-chart summarization only.

## 2. Inputs

**Schema:**

```
{
  "chart_type": "string",            // enum: line | bar | area | pie | scatter | table | combo
  "title": "string",                 // chart title as set by the author
  "axes": {                          // axis labels and units
    "x": { "label": "string", "unit": "string" },
    "y": { "label": "string", "unit": "string" }
  },
  "series": [                        // one entry per plotted series
    {
      "name": "string",
      "points": [{ "x": "any", "y": "number" }]
    }
  ],
  "annotations": ["string"],         // any author-added callouts
  "dashboard_context": "string"      // dashboard title + section heading, if any
}
```

**Example value (real, not a placeholder):**

```
{
  "chart_type": "line",
  "title": "Weekly Active Users — Web",
  "axes": {
    "x": { "label": "Week starting", "unit": "date" },
    "y": { "label": "WAU", "unit": "users" }
  },
  "series": [
    {
      "name": "WAU",
      "points": [
        { "x": "2026-03-02", "y": 412000 },
        { "x": "2026-03-09", "y": 418500 },
        { "x": "2026-03-16", "y": 421200 },
        { "x": "2026-03-23", "y": 405800 },
        { "x": "2026-03-30", "y": 437100 },
        { "x": "2026-04-06", "y": 451900 },
        { "x": "2026-04-13", "y": 449200 }
      ]
    }
  ],
  "annotations": ["Mar 30: new onboarding flow shipped"],
  "dashboard_context": "Growth — Acquisition"
}
```

**Max sizes:**

| Field | Max size | Unit | If exceeded |
|-------|----------|------|-------------|
| series | 8 | series | reject — show "too many series to summarize" message |
| series[].points | 365 | points | downsample to 365 evenly-spaced points before send |
| title | 200 | chars | truncate with ellipsis |
| dashboard_context | 500 | chars | truncate with ellipsis |
| total payload | `[?]` | tokens | `[OWNER: ?]` — see Section 9 |

## 3. Outputs

**Schema:**

```
{
  "summary": "string",     // 2 paragraphs, plain text, no markdown
  "confidence": "string",  // enum: high | medium | low
  "model_version": "string"
}
```

**Example value (fully populated):**

```
{
  "summary": "Weekly active users on web have grown from about 412k to 449k over the last seven weeks, an increase of roughly 9%. The trend is steady upward with one dip in the week of March 23 before recovering the following week.\n\nThe author annotated that a new onboarding flow shipped on March 30, which coincides with the largest week-over-week jump in the series (+31k users). The most recent two weeks show signs of leveling off, suggesting the onboarding lift may be settling into a new baseline rather than continuing to compound.",
  "confidence": "high",
  "model_version": "frontier-llm-2026-04"
}
```

**Format validation rules:**

- `summary` is exactly 2 paragraphs separated by `\n\n`, each 2–5 sentences, total length 400–800 characters.
- `summary` must reference only numbers and entities present in the input (no fabricated values, no unmentioned competitors).
- `summary` must not contain markdown headers, bullets, or bold/italic syntax.
- `summary` must not include calls to action, hedging filler ("It's important to note that…"), or meta-commentary about the chart's design.
- `confidence` defaults to `medium`; downgrade to `low` if any series has fewer than 5 points or the chart_type is `combo`.

## 4. Model contract

| Field | Value | Notes |
|-------|-------|-------|
| Model family | Frontier LLM, text-only | Numeric reasoning over series data; vision not required since we pass structured data, not the rendered image. |
| Tier | Mid-tier (Sonnet-class or equivalent) | Cheaper tiers fail format adherence at >10% in internal pilots; frontier-top is overkill for 2-paragraph summarization. |
| Expected p95 latency | `[? — target 2000ms]` | User clicks button and waits — perceived budget is ~2s before they bail. `[OWNER: ?]` — needs `/cost-latency-budgeter`. |
| Expected cost per call | `[?]` USD | Depends on payload size after downsampling. `[OWNER: ?]` — needs `/cost-latency-budgeter`. |

**Why this tier:** Mid-tier is needed for two things — adhering to the 2-paragraph format under varied input shapes, and correctly interpreting axis units (e.g., "WAU" vs. "MAU" vs. "DAU"). A cheaper tier can summarize, but loses the format and unit reliability that makes the output trustworthy at a glance.

## 5. Failure modes

| # | Failure mode | Why it happens | Detection signal |
|---|--------------|----------------|------------------|
| 1 | Hallucinated number not present in series | Model interpolates or rounds to "nicer" numbers | Post-hoc check: every number in summary must appear in input within ±2% tolerance |
| 2 | Misreads the axis unit (e.g., calls WAU "DAU") | Compact labels like "WAU" are ambiguous without context | Post-hoc check: any user/revenue/time term in summary must match a token in axes.y.label or title |
| 3 | Invents a cause for a dip or spike | Model pattern-matches to "explain the change" instead of describing it | Assertion: summary may reference annotations[] verbatim but must not introduce new causal claims |
| 4 | Output is 1 or 3 paragraphs, not 2 | Format adherence drift on edge cases | Validation rule: split on `\n\n`, reject if count != 2 |
| 5 | Misidentifies trend direction on noisy series | Model anchors on first/last point instead of fitting | Assertion: compute simple linear fit server-side; if summary trend word disagrees with fit sign, mark low-confidence |

> Run `/hallucination-profiler` against this feature to deepen this section — chart summarization is a known-grounded task and the taxonomy has 12+ relevant modes.

## 6. Fallback policy

| Failure case | What the user sees | What gets logged |
|--------------|-------------------|------------------|
| Model error (5xx, JSON parse failure, validation failure) | Inline message: "Summary unavailable — try again" with a retry link. Chart remains fully usable. | error_code, input_hash, model_version, raw_output (first 500 chars) |
| Timeout (> 3000ms wall clock) | Same inline message + "(took too long)" suffix. Cancel the in-flight request. | timeout flag, latency_ms, input_hash |
| Low-confidence output (failed post-hoc number check, mismatched trend direction, format violation) | Summary is shown with a "Low confidence — verify against chart" banner above it. User can dismiss banner. | confidence_signal, which_check_failed, input_hash, raw_output |

## 7. Eval seed

| # | Input | Expected output (shape or content) | Pass criteria |
|---|-------|-------------------------------------|---------------|
| 1 | Line chart, WAU over 7 weeks, steady upward trend, one annotation about an onboarding ship date | 2 paragraphs: ¶1 describes the upward trend with magnitude; ¶2 references the annotation as context without inventing a causal claim | Numbers in summary all appear in input; "increase/grew/up" appears once; annotation is mentioned but not asserted as cause |
| 2 | Bar chart, revenue by region (5 regions), one region 4× larger than the rest, no annotations | 2 paragraphs: ¶1 names the dominant region with its share; ¶2 describes the remaining distribution | Dominant region is named correctly; no region is invented; no annotation is fabricated |
| 3 | Pie chart, 3 slices, near-even split (35/33/32) | 2 paragraphs: ¶1 states the near-even split; ¶2 names each slice with its share | Summary explicitly notes the near-equal distribution; all 3 slices are named |
| 4 | Line chart, 30 days of DAU, flat with high day-to-day noise, no trend | 2 paragraphs: ¶1 states the series is roughly flat with noise; ¶2 describes the range (min/max) without claiming a trend | Summary does NOT use directional words like "increasing" or "decreasing"; "flat", "stable", or "no clear trend" appears |
| 5 | Scatter plot, 100 points, weak positive correlation, axes labeled "Ad spend" and "Conversions" | 2 paragraphs: ¶1 states the weak positive relationship with appropriate hedging; ¶2 notes the spread/variance | Hedging language present ("weak", "loose", "tendency"); no specific correlation coefficient invented |

**Rubric (1 paragraph):** Reviewers grade on four dimensions in priority order: (a) **faithfulness** — every number, entity, and causal claim must trace to the input; this is non-negotiable and a single fabrication fails the row regardless of other quality. (b) **format adherence** — exactly 2 paragraphs, 400–800 chars, no markdown; format violations fail the row. (c) **trend accuracy** — direction and magnitude descriptions must match what a careful reader would conclude; reviewers should fit the data mentally before reading the summary. (d) **usefulness** — does the summary tell the user something they wouldn't get from a 2-second glance at the chart? Trade-offs: prefer terse-and-correct over rich-and-uncertain; when in doubt, the model should hedge rather than assert. Borderline cases on (d) are PASS as long as (a)–(c) are clean.

## 8. Telemetry

| Field | Type | Notes |
|-------|------|-------|
| `input_hash` | string | SHA-256 of canonicalized input JSON; no raw chart data logged. |
| `chart_type` | enum | line / bar / area / pie / scatter / table / combo. |
| `series_count` | int | Helps segment performance by chart complexity. |
| `point_count_total` | int | Sum across series; correlates with payload size and latency. |
| `model_version` | string | Includes prompt version, e.g., `frontier-llm-2026-04 / prompt-v3`. |
| `prompt_version` | string | Separate field for easier slicing. |
| `latency_ms` | int | Wall-clock from request to response. |
| `output_length_chars` | int | Logged instead of raw output unless user opts into share-with-team mode. |
| `validation_result` | enum | passed / failed_format / failed_numbers / failed_trend. |
| `confidence` | enum | high / medium / low — server-assigned. |
| `user_action` | enum | dismissed / kept_open / copied / regenerated / reported / none (timeout). |
| `fallback_shown` | bool | True if the user saw the low-confidence banner or the error state. |

## 9. Open questions

- [ ] What is the total payload token max before we need server-side chunking or summarization-of-summaries? `[OWNER: ?]`
- [ ] What is the p95 latency budget — is 2s the right ceiling, or does user research support 1s? `[OWNER: ?]` — run `/cost-latency-budgeter`.
- [ ] What is the per-call cost ceiling, and what is the expected traffic (clicks/day at launch and at 6 months)? `[OWNER: ?]` — feeds the same budgeter run.
- [ ] Does the BI tool render charts the user authored differently from charts shared by others? If so, do we want different prompts for "your chart" vs. "someone else's chart"? `[OWNER: ?]`
- [ ] Assumed English-only at launch — confirm with PM. Localization plan? `[OWNER: ?]`
- [ ] Are we logging `output` in full or hashing it? PII risk depends on whether chart titles can contain customer names. `[OWNER: ?]`
- [ ] For `combo` chart types, do we ship at launch or scope out? Current spec downgrades confidence — is that acceptable? `[OWNER: ?]`
- [ ] Who owns the post-hoc number-check assertion — frontend or a server-side validator? `[OWNER: ?]`
