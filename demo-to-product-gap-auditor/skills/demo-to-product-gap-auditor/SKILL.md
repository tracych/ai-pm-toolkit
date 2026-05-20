---
name: demo-to-product-gap-auditor
description: |
  Pre-launch audit skill for AI features. Given a working AI demo (what it does, what model/infra, current state, target launch audience), scores readiness 1–5 across 10 dimensions — latency-at-scale, cost-at-scale, eval coverage, abuse defense, monitoring, fallback, UX trust signals, comms readiness, on-call story, retrain story — names the single biggest concrete gap per dimension, proposes the minimum fix to reach "acceptable risk" (4/5), and triages must-fix-before-launch vs ship-with-known-gap. Refuses to render "ready to ship" framing when 3+ dimensions score 1–2. Use when the user wants to: pressure-test whether an AI demo is actually launchable, generate a pre-launch readiness checklist, decide which gaps must be fixed before ship vs which can ship with an owner and a known mitigation, or produce an interactive HTML scorecard the team can check off.

  Do NOT trigger for: building a prototype that doesn't exist yet (use protopilot), drafting a feature spec from scratch (use ai-feature-spec or prd-to-prompt), running a post-launch retrospective (use retro-facilitator), or auditing features that don't involve a model (this skill assumes an LLM/ML component).
---

# demo-to-product-gap-auditor (skill)

Audit the gap between a working AI demo and a shippable product across 10 dimensions. The scorecard is the receipts. The triage is the call to action.

## Operating principles

- **Score honestly.** Most AI demos score 1–2 on 4+ dimensions. Do not soft-pedal scores to make the team feel ready. The audit is useful only if it reflects reality.
- **Ship bar is "acceptable risk," not "perfect."** A 4/5 with a documented gap and a named owner is shippable. A 1/5 with a TODO is not. Calibrate the "minimum fix" to 4, not 5.
- **Monitoring + on-call are mandatory dimensions.** Most AI features ship with no rotation and the founding PM becomes oncall by default. Always surface this even if the team would rather not look.
- **Fallback policy is a dimension.** A demo with no fallback is a demo. "Show a static error message" counts as a fallback *if explicitly designed*. Implicit "the request just fails" is a 1.
- **Comms readiness includes the failure narrative.** If launch comms have no story for "what we say when the model is wrong," score it 2 regardless of how polished the rest is.
- **Refuse premature ship framing.** If 3+ dimensions score 1–2, the verdict is `STILL A DEMO` and the artifact says so plainly. Do not generate a "ready to ship" summary in that case.

## Inputs

The skill needs four things. If any are missing from `$ARGUMENTS` or the conversation, ask before scoring:

1. **What the demo does** — one sentence on the user-visible behavior.
2. **What model + infra it uses** — model name/provider, any retrieval/tools/agents, where it runs.
3. **Current state of the implementation** — is it a Notion-doc demo, an internal endpoint, a feature flag in prod, etc.
4. **Target launch surface + audience size** — who is going to use it, how many of them, on what timeline.

If the input is missing 2+ of these, respond with a single ask:

> "I need four things to audit this honestly: (1) what the demo does, (2) what model + infra, (3) current implementation state, (4) target launch surface + audience size. Paste what you have — rough is fine."

Do not proceed until you have at least 3 of the 4.

## Step 1 — Load the audit dimensions

Read `assets/audit-dimensions.md` (relative to this skill). It defines the 10 dimensions with anchor descriptions for scores 1, 3, and 5, plus common gap patterns. Use those anchors — do not invent your own scale.

## Step 2 — Score all 10 dimensions

For each dimension, assign an integer score 1–5. For each:

- **Rationale** — 1 sentence tied to the actual input. Quote the user's phrase when possible.
- **Biggest gap** — one concrete thing, named in plain language. Not "needs more evals" — "no eval set exists for the top-3 cold-outreach personas, so we'd ship blind on the segments that matter most."
- **Minimum fix** — what gets this to a 4. Cheapest defensible version, not gold-plated. Should be sized in days or weeks, not quarters.

Format internally as a structured table the artifacts will render from.

## Step 3 — Compute the verdict

Count dimensions scoring 1 or 2. Apply this rule:

- **0 dimensions at 1–2** → verdict `READY` (green banner).
- **1–2 dimensions at 1–2** → verdict `SHIP WITH KNOWN GAPS` (yellow banner). The 1–2s become the must-fix-or-document list.
- **3+ dimensions at 1–2** → verdict `STILL A DEMO` (red banner). **Refuse to render "ready to ship" framing.** The artifact must say "this is not yet a product" at the top.

Pick the **3 must-fix-before-launch items**: the 3 lowest-scoring dimensions, breaking ties by which gap has the highest blast radius (monitoring/on-call/fallback/abuse defense outrank cost/latency/retrain on ties).

## Step 4 — Generate a slug

Slug = first 3–5 words of "what the demo does," lowercased, hyphenated, ASCII only. Example: `sales-rep-cold-outreach-drafter`.

## Step 5 — Write the three output files

Create `demo-to-product-audit/<slug>/` in the current working directory and write:

### `audit.md` (executive summary)

```
# Demo-to-Product Gap Audit — <slug>

**Verdict:** READY | SHIP WITH KNOWN GAPS | STILL A DEMO
**Score:** X / 50
**Dimensions at 1–2:** N

## Must-fix before launch (top 3)
1. **<dimension>** — <gap>. Minimum fix: <fix>. Owner: _____
2. ...
3. ...

## Full scorecard
| # | Dimension | Score | Gap | Minimum fix |
|---|-----------|-------|-----|-------------|
| 1 | Latency-at-scale | 3/5 | ... | ... |
| ... | ... | ... | ... | ... |

## If shipping with known gaps — say this in launch comms
<2–4 sentences: how to honestly describe the known gaps + the fallback policy in launch comms. Composes with /comms-pack.>

## If verdict is STILL A DEMO
<Replace the "say this in launch comms" section with: "Do not ship yet. The following dimensions need to clear 3/5 before launch comms make sense: <list>.">
```

### `audit.html` (interactive checklist)

Copy `assets/audit_template.html` to `demo-to-product-audit/<slug>/audit.html`, then string-substitute placeholders to inject:

- `__SLUG__` → the slug
- `__VERDICT__` → READY / SHIP WITH KNOWN GAPS / STILL A DEMO
- `__VERDICT_CLASS__` → `green` / `yellow` / `red`
- `__TOTAL_SCORE__` → X / 50
- `__DIMENSIONS_JSON__` → the scorecard as a JSON array embedded in a `<script>` tag, used by the page to render dimension cards on load (score sliders default to your scored value; gap/fix text inputs prefilled; "we'll fix this" checkboxes default unchecked; owner field empty).

The template must already include: 10 dimension cards driven by the JSON, score sliders 1–5, gap textarea, fix textarea, owner input, checkbox, localStorage save (auto on change), JSON export button, ship-readiness banner styled by `__VERDICT_CLASS__`. No CDN, no external resources, single self-contained file.

### `audit.json` (machine-readable scorecard)

```json
{
  "slug": "...",
  "verdict": "READY|SHIP_WITH_KNOWN_GAPS|STILL_A_DEMO",
  "total_score": 32,
  "dimensions_at_low": 3,
  "must_fix": ["dimension-a", "dimension-b", "dimension-c"],
  "dimensions": [
    {
      "id": "latency-at-scale",
      "name": "Latency at scale",
      "score": 3,
      "rationale": "...",
      "gap": "...",
      "fix": "..."
    }
  ]
}
```

## Step 6 — Report back

After writing the three files, report:

1. Absolute path to each of the three files.
2. The verdict (READY / SHIP WITH KNOWN GAPS / STILL A DEMO) and the total score.
3. The 3 must-fix items by name.
4. Which downstream skill to chain next (e.g., "cost-at-scale scored 2 → `/cost-latency-budgeter`"; "abuse defense scored 1 → `/ai-redteam-prompts`"; "no on-call rotation → `/rollback-planner`"; "comms missing failure narrative → `/comms-pack`").

## How this skill differs from adjacent skills

- **`protopilot`** — builds the demo. This skill audits the demo. Use protopilot first if there's nothing to audit yet.
- **`ai-feature-spec` / `prd-to-prompt`** — define what to build. This skill judges what was built against ship criteria.
- **`retro-facilitator`** — post-launch reflection. This skill is pre-launch — the whole point is to catch the gaps before they become retro material.
- **`premortem`** — imagines failure modes for a plan that doesn't exist yet. This skill measures failure-readiness of an implementation that already exists.
- **`cost-latency-budgeter` / `hallucination-profiler` / `ai-redteam-prompts` / `rollback-planner` / `comms-pack`** — each goes deep on one dimension. This skill is the breadth pass that tells you *which* deep dives to run.
