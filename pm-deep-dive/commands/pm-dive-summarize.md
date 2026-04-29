---
displayName: 'PM Dive — Summarize'
description: 'Read all raw agent outputs in a dive folder, produce the cross-validation matrix, claim verdict, HIGH-confidence findings, and the open-questions artifact. Uses a triple-check cross-validation pattern.'
---

# /pm-dive-summarize

**Stage 5 of pm-deep-dive.** Cross-validates findings across angles and validators, produces the canonical `00_SUMMARY.md` and `OPEN_QUESTIONS_LOWER_CONFIDENCE.md`.

## Approach

Uses a triple-check cross-validation pattern, with a PM-specific HIGH≥3 rubric and a falsifiable-claim verdict.

## Phase 0 — Load dive

1. Locate dive folder (cwd or argument).
2. Read `frame.json` for the claim, angles, and `domain_maturity` (default `established` if absent).
3. Read angle outputs: `0[1-6]_*.md` files in the folder.
4. Read validators separately (so they aren't double-counted as angles): `validation_code.md`, `validation_knowledge.md`.
5. Confirm Phase 1 + Phase 2 outputs exist. If validation files are missing, note as a gap to surface. If `validation_code.md` says `Skipped: domain_maturity=new_bet`, treat as expected skip — NOT a gap.

## Phase 1 — Build cross-validation matrix

For every claim that appears in any angle file:
1. Tag which angle files mention it.
2. Apply the rubric from `assets/confidence_rubric.md` — **the bar depends on `frame.domain_maturity`:**

   For `established` (default — strict bar):
   - **HIGH**: ≥3 angle files agree, OR ≥1 angle + code-validation confirms
   - **MEDIUM**: 2 angle files agree, no code confirmation
   - **LOW**: 1 angle file, or contested across angles

   For `new_bet` (relaxed bar — code absence is expected, not disqualifying):
   - **HIGH**: ≥3 angle files agree, OR ≥1 angle + knowledge re-validator confirms with a fresh source
   - **MEDIUM**: 2 angle files agree
   - **LOW**: 1 angle file, or contested
   - Code validator UNFOUND does NOT downgrade (it was skipped by design)

3. Tag whether validator CONFIRMED, REFUTED, or UNFOUND each claim.
4. Note any claims the validator REFUTED — these become reversals (same in both modes).

## Phase 2 — Verdict on the claim

Based on the matrix, classify the dive claim itself as:
- **CONFIRMED** — multiple HIGH-confidence findings substantiate the claim
- **REFUTED** — validator or angle evidence contradicts the claim
- **PARTIALLY CONFIRMED** — claim holds with caveats or scope reduction

If validator reversed any claims that the angle agents had marked HIGH, write a one-paragraph "What validation changed" section. **Do not hide reversals.**

## Phase 3 — Write 00_SUMMARY.md

Schema:

```markdown
# {Dive title} — Validated Synthesis

**Question:** {claim}
**Date:** {YYYY-MM-DD}
**Method:** N parallel research agents + M validation agents
**Domain maturity:** {established | new_bet} — {HIGH bar requires code/data validation | HIGH bar is angle-agreement; code validator skipped by design}
**Companion files:** 01_*.md ... 0N_*.md, validation_code.md, validation_knowledge.md

## Verdict on the claim
{CONFIRMED / REFUTED / PARTIALLY CONFIRMED — one paragraph, with what changed if validation reversed anything}

## TL;DR (one paragraph)
{Single dense paragraph — leadership-readable}

## Cross-validation matrix
| # | Claim | Cross-validation | Confidence | Validator |
|---|-------|------------------|-----------|-----------|
| 1 | ... | 01 + 02 + 03 ✓✓✓ | HIGH | CONFIRMED |
| 2 | ... | 02 + 04 ✓✓ | MEDIUM | UNFOUND |

## High-confidence findings (act on these)
{Numbered findings with sources}

## What validation changed
{Reversals surfaced openly — do not hide. Omit section if no reversals.}

## Validation gap (if any)
- Which HIGH-confidence claims are code-grounded vs. wiki/doc-grounded only
- Which negative claims ("we have no X") are negative-inference and need code confirmation before quoting to leadership
- Top 3 priority claims for the next validator re-run

## Suggested follow-ups
{People to meet / docs to read / claims to verify — NOT auto-created as tasks}
```

## Phase 4 — Write OPEN_QUESTIONS_LOWER_CONFIDENCE.md

For each MEDIUM/LOW claim:

```markdown
## {Claim}
- **Status:** what's known, what's not
- **Caveat:** why it didn't make HIGH cut
- **Next step:** named action with effort estimate (e.g. "1-day audit", "scope with X")
```

This is a **first-class artifact**, not buried. The most important deliverable for the next dive.

## Phase 5 — Hand off

Print to user:

> Synthesis complete. Verdict: {CONFIRMED / REFUTED / PARTIAL}
>
> Top 3 highest-confidence findings:
> 1. ...
> 2. ...
> 3. ...
>
> Top 3 follow-ups:
> 1. ...
>
> Files written:
> - 00_SUMMARY.md
> - OPEN_QUESTIONS_LOWER_CONFIDENCE.md
>
> Next: `/pm-dive-ship` to productize, or `/pm-dive-land` to feed into project knowledge. Or stop here — the SUMMARY is the canonical deliverable.

**Do not auto-productize.** PM decides what to ship.

---

## Anti-patterns

- ❌ HIGH confidence on single-source claims
- ❌ Hide reversals or downgrade them silently
- ❌ Auto-create tasks in your task tracker for follow-ups
- ❌ Drop the open-questions file
- ❌ Skip the validation gap section when validator was incomplete

## Standalone use

A PM with their own dive folder (raw agent outputs from any source — another LLM agent, manual notes, copy-pasted research) can call `/pm-dive-summarize` and get the cross-validation matrix without running anything else.
