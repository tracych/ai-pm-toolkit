---
name: problem-statement-doctor
description: |
  Diagnostic skill that scores a draft PM problem statement against an 8-rubric checklist (specificity, user-centricity, measurability, falsifiability, scope, urgency, evidence quality, falsifiable success criteria), then produces three rewritten versions at distinct specificity levels (broad / focused / surgical) with trade-off annotations and an audience-fit guide. Use when the user wants to: pressure-test a problem statement before writing a PRD, get a second opinion on whether their framing is tight, generate alternative framings for different stakeholders (exec / team / sprint), or clean up a vague problem brief into something a research or build workflow can consume.

  Do NOT trigger for: generating new problem statements from scratch with no draft (ask for one first), running primary research to discover problems (use pm-deep-dive), or building a prototype from an already-validated problem (use protopilot).
---

# problem-statement-doctor (skill)

Diagnose a PM problem statement, then rewrite it three ways. The scorecard is the receipts; the rewrites are the options.

## Operating principles

- **Diagnose before prescribing.** Always score all 8 rubrics first — the rewrites must explicitly address the weakest dimensions.
- **Three specificity levels are non-negotiable.** Broad / focused / surgical each serve a different audience. Do not collapse to one "best" rewrite.
- **Refuse fragments.** If the input is fewer than 10 words, do NOT score. Ask the user to paste a fuller draft (at minimum: who is affected, what's broken, why it matters).
- **No fabricated evidence.** If the input lacks data, score "evidence quality" as 1–2 and call it out in the rationale. Do not invent percentages or user counts in the rewrites — use bracketed placeholders like `[X% of users]` instead.
- **Plain language.** If the input contains company-internal acronyms or jargon, flag them in the scorecard rationale for "specificity" and use plain-English substitutes in the rewrites.

## Inputs

- A draft problem statement, passed as `$ARGUMENTS` or pasted into the conversation.

If empty or under 10 words: respond with a single ask:

> "I need a fuller draft to diagnose. Paste at least: (1) who is affected, (2) what's broken or unmet, (3) why it matters. Even a rough paragraph is fine."

Do not proceed until the user provides one.

## Step 1 — Load the rubric

Read `assets/rubric.md` (relative to this skill). It defines the 8 scoring dimensions with anchor descriptions for scores 1, 3, and 5. Use those anchors — do not invent your own scale.

## Step 2 — Score all 8 rubrics

For each rubric, assign an integer score 1–5 and write a 1-sentence rationale tied to the actual input text. Be specific: quote the phrase that earned the score when possible.

Format as a markdown table:

| # | Rubric | Score | Rationale |
|---|--------|-------|-----------|
| 1 | Specificity | 2/5 | "Onboarding is confusing" — no named step, persona, or surface. |
| ... | ... | ... | ... |

Total the scores at the bottom (`Total: X / 40`). Do not editorialize on the total — the rewrites are the response.

## Step 3 — Produce three rewrites

Generate three versions at distinct specificity levels. Each must be self-contained (could stand alone in a doc).

### Broad (executive framing)
- 1–2 sentences. Names the user segment, the unmet outcome, and the strategic stakes. No tactical detail.
- **Use for:** board memos, leadership previews, all-hands narrative, OKR rationale.
- **Trade-off:** easy to nod along to, hard to disagree with — which means it can hide unresolved scoping debates.

### Focused (team-ready)
- 3–5 sentences or a short structured block. Names the user, the specific moment, the observable symptom, the rough magnitude (use `[bracketed placeholders]` if the input lacked data), and the success signal.
- **Use for:** PRDs, design briefs, kickoffs, cross-functional sync docs.
- **Trade-off:** specific enough to align a team, broad enough that scope can still drift in the first sprint.

### Surgical (sprint-scoped)
- A tightly scoped statement naming: one user segment, one moment in the journey, one observable behavior, one falsifiable success metric, and one explicit out-of-scope clause.
- **Use for:** sprint tickets, experiment design, hypothesis testing, `/pm-dive-frame` seed claims.
- **Trade-off:** forces commitment to a slice — may miss adjacent problems worth solving together.

For each rewrite, include a one-line **"What changed and why"** note tying the rewrite back to the weakest rubric scores it addresses.

## Step 4 — Audience-fit guide

End the artifact with a short table:

| If your audience is... | Use this version | Because |
|------------------------|------------------|---------|
| Exec / leadership | Broad | They need stakes and direction, not tactics. |
| XFN team / PRD readers | Focused | Specific enough to align; not so narrow it preempts design. |
| Sprint / experiment owner | Surgical | One slice, one metric, one out-of-scope clause. |
| Strategy research seed | Surgical or Focused | Falsifiable framing makes for better orthogonal angles. |

## Step 5 — Write the output

Write everything to `problem-statement.md` in the current working directory. Structure:

```
# Problem Statement Doctor — <short slug from input>

## Original
> <verbatim input>

## Scorecard
<the 8-row table + total>

## Rewrites
### Broad
<rewrite>
*What changed and why:* ...

### Focused
<rewrite>
*What changed and why:* ...

### Surgical
<rewrite>
*What changed and why:* ...

## Pick the framing
<audience-fit table>

## Notes
<any flagged readability risks, missing evidence, or scoping ambiguities>
```

After writing, report:

1. Absolute path to `problem-statement.md`
2. The total score (X / 40) and the two weakest rubrics
3. Which rewrite you'd hand to the next workflow (e.g., "surgical → `/pm-dive-frame`")

## How this skill differs from adjacent skills

- **`pm-deep-dive`** — investigates whether a *claim* holds up via parallel research. problem-statement-doctor cleans up the claim *before* you spend agents on it.
- **`protopilot`** — turns a validated problem into a clickable mock. problem-statement-doctor validates the problem framing first.
- **Generic "rewrite this" prompts** — produce one rewrite with no diagnostic. This skill scores first, then offers three options at known trade-offs.
