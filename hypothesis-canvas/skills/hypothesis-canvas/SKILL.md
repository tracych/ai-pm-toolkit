---
name: hypothesis-canvas
description: |
  Convert a fuzzy product idea or change description into a falsifiable, A/B-ready hypothesis with six mandatory fields (change, metric, magnitude, segment, mechanism, abandon-if) and render it as a self-contained HTML canvas plus markdown plus JSON. Use when the user wants to: turn a rough idea into a testable hypothesis, write a kill criterion before starting work, prep a change for an A/B test, or pressure-test whether an idea is even falsifiable. Triggers on language like "frame this as a hypothesis", "make this A/B-ready", "what's the falsifier for X", "hypothesis canvas for this change", "what would make me kill this".

  Do NOT trigger for: production experiment configuration / stats analysis, generative discovery research where there is nothing to falsify yet, or roadmap-level strategy framing where the claim is still too broad to test (use pm-deep-dive first).
---

# hypothesis-canvas (skill)

Take a PM from a fuzzy idea to a single falsifiable hypothesis with a kill criterion they will actually honor. Output is three files: `hypothesis.html` (editable single-file canvas), `hypothesis.md` (paste into docs), and `hypothesis.json` (machine-readable).

## The structured hypothesis

Every canvas resolves to one sentence in this exact shape:

> If we change **<change>** for **<segment>**, we expect **<metric>** to move by **<magnitude>** within **<window>**, because **<mechanism>**. We will abandon if **<abandon-if>**.

Six mandatory fields. No skipping.

| Field | What good looks like | What's not allowed |
|---|---|---|
| `change` | One concrete shipped thing. "Add a 3-day streak counter on home." | "Improve retention." (that's the outcome, not the change) |
| `metric` | One named, instrumented metric. "D7 retention (logged-in users)." | "Engagement." Two metrics. |
| `magnitude` | Numeric + direction + window. "+2.5pp absolute, within 4 weeks." | "Goes up." "Significant." No number. |
| `segment` | A defined cohort. "First-time creators in week 1." | "All users." Undefined. |
| `mechanism` | One-sentence causal story. "Streaks create a daily anchor that pulls users back before habit decays." | Hand-wave ("because growth"). |
| `abandon-if` | A concrete observable that would make you kill it. "If D7 movement is <+0.5pp after 4 weeks with N≥50k per arm, we kill the feature and roll back." | "If it doesn't work." "If we don't like the result." |

The window is part of `magnitude` — every magnitude must carry its time horizon.

## Operating principles

- **Falsifiable or it doesn't exist.** If you cannot produce a concrete, numeric or observable `abandon-if`, REFUSE to write the artifacts. Tell the PM: "I can't render this until you name a kill criterion. What number or observation would make you stop?"
- **One change, one metric.** If the PM names two metrics, ask which is primary and demote the rest to "secondary, not gating."
- **Push for numbers.** Reject "improve", "lift", "significantly". Ask: "by how much, measured how, by when?"
- **Push for segments.** "All users" is almost never the right cohort. Ask who is most likely to respond and why.
- **Mechanism gets one sentence.** If the PM can't articulate the causal story in one sentence, the hypothesis isn't ready — surface that.
- **Self-contained artifact.** The HTML opens with a double-click. No build, no CDN, no server. Inline CSS, vanilla JS, localStorage save, JSON export via data-URI.

## Workflow

### Step 0 — Intake

If the PM's input is empty or just a topic, ask in a single batch:

- What's the change? (One concrete thing you'd ship.)
- Which metric will move? (Name it precisely.)
- How much, by when? (Number + direction + window.)
- Which segment will respond first? (Cohort definition.)
- Why? One sentence on mechanism.
- What kill criterion would you honor?

Derive a `<slug>` (kebab-case, 2–4 words) from the change — this names the output folder.

### Step 1 — Draft

Fill all 6 fields. Show the PM the draft hypothesis sentence in the structured form above. Call out any field that's still weak (e.g. "your magnitude has no window — pick one").

### Step 2 — Gate on abandon-if

If `abandon-if` is missing, vague, or non-observable, **STOP**. Do not write files. Respond:

> I can't render this canvas yet. The `abandon-if` field is mandatory and yours is still [missing / vague / non-observable]. What concrete observation — a number, a threshold, a deadline — would make you kill this work and roll it back?

Loop with the PM until they commit to a concrete kill criterion. Only then proceed.

### Step 3 — Render artifacts

Write three files to `hypothesis-canvas/canvases/<slug>/`:

**`hypothesis.html`** — copy `hypothesis-canvas/assets/canvas_template.html` and prefill the six fields. The template already includes:
- 6 labeled inputs/textareas (`change`, `metric`, `magnitude`, `segment`, `mechanism`, `abandon-if`)
- An "Export JSON" button (downloads `hypothesis.json` via data-URI)
- A "Save to browser" button (localStorage)
- A red banner element `#abandon-banner` that auto-shows when `abandon-if` is empty

To prefill: do a small string replacement so the `value` / inner text of each field is populated. Do not change the template's structure or strip the banner logic.

**`hypothesis.md`** — markdown version, paste-into-docs friendly:

```markdown
# Hypothesis: <change-summary>

> If we change **<change>** for **<segment>**, we expect **<metric>** to move by **<magnitude>**, because **<mechanism>**. We will abandon if **<abandon-if>**.

## Fields

- **Change:** <change>
- **Metric:** <metric>
- **Magnitude:** <magnitude>
- **Segment:** <segment>
- **Mechanism:** <mechanism>
- **Abandon if:** <abandon-if>
```

**`hypothesis.json`** — machine-readable:

```json
{
  "change": "...",
  "metric": "...",
  "magnitude": "...",
  "segment": "...",
  "mechanism": "...",
  "abandon_if": "...",
  "structured": "If we change ... for ..., we expect ... to move by ..., because .... We will abandon if ..."
}
```

### Step 4 — Report

After writing, return:

1. Absolute paths to all 3 files.
2. The structured hypothesis sentence inline.
3. The `abandon-if` quoted by itself (so the PM sees their own kill criterion clearly).
4. Offer: refine any field, or ship as-is.

## Iteration

When the PM comes back ("the magnitude is too aggressive" / "swap the segment"):
- Update the relevant fields, re-run the abandon-if gate, overwrite all 3 files in place.
- Do not version. The PM can `cp` the folder if they want variants.

## How this skill differs from adjacent skills

- **assumption-tracker** — tracks assumptions over time. hypothesis-canvas produces the single falsifiable claim those assumptions hang off of.
- **pm-deep-dive** — investigates whether a claim is even worth testing. hypothesis-canvas assumes the claim is worth testing and forces it into A/B-ready shape.
- **Generic PRD / spec templates** — capture intent. hypothesis-canvas captures the falsifier.
