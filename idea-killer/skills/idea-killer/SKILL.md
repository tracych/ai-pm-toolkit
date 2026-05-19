---
name: idea-killer
description: |
  Adversarial pre-mortem skill that generates the 7 strongest reasons a product idea will fail, ranked by likelihood × consequence, each paired with the cheapest falsification test a PM can run in under a week. Use when the user wants to: pressure-test an idea before committing resources, run a pre-mortem on a product or feature concept, stress-test a pitch, generate abandon-if conditions, or get an explicitly non-sycophantic adversarial read on a proposal. Triggers on language like "kill this idea", "pre-mortem", "what could go wrong with", "steel-man the no", "why would this fail", "stress test this", "idea-killer <idea>".

  Do NOT trigger for: validating an idea you want to ship (this skill is built to kill, not encourage), post-mortems on shipped products (wrong artifact), quantitative market sizing (use a research skill), or ideas described in fewer than 10 words — the skill refuses these and asks for elaboration.
---

# idea-killer (skill)

Generate a `kill-report.md` that surfaces the 7 strongest reasons a product idea will fail, ranks them, and pairs each with a falsification test cheaper than a week of PM time. Counter-sycophantic by design: this skill is not here to find the bright side.

## Operating principles

- **Steel-man the no.** Argue against the idea as forcefully as the strongest skeptic in the room would. Be specific, not generic.
- **All 7 categories, every time.** Demand, distribution, competition, regulation, unit economics, organization/team, timing. No skipping. If a category seems "not applicable," that itself is a failure mode — write it.
- **Falsification > opinion.** Every failure mode must end with a test the PM can run in <1 week. If you can't name a concrete test, the failure mode is too abstract — rewrite it sharper.
- **No sycophancy.** Do not open with praise. Do not soften with "but the upside is...". Do not hedge ranks. The closing gate is the only place the PM gets to decide whether to fund.
- **Specific over generic.** "Users won't pay" is not a finding. "SMB owners under $1M revenue churn out of $30+/mo tools with no week-one ROI" is a finding.

## Phase 0 — Intake check

If `$ARGUMENTS` is fewer than 10 words (count whitespace-separated tokens), refuse:

```
The idea you gave me is too short for an honest pre-mortem.
Give me 1-3 sentences covering: what it is, who it's for, and how it makes money (or how it grows).
Then re-run /idea-killer.
```

Stop. Do not produce a report.

Otherwise, derive a `<slug>` (kebab-case, 2-4 words) from the idea. This names the output folder: `idea-killer/reports/<slug>/`.

## Phase 1 — Frame the idea (internal, one paragraph)

Before generating failure modes, restate the idea in your own words in 2-3 sentences covering: **what**, **who for**, **how it makes money or grows**. If any of these three is missing from the user's input, infer the most charitable plausible answer and flag it explicitly in the report's intro — those inferred gaps are themselves likely failure modes.

## Phase 2 — Generate all 7 failure modes

Load `idea-killer/assets/failure_modes.md` for the category prompt structure. For each of the 7 categories, write:

- **Failure mode** — one declarative sentence stating *how* this idea dies on this axis. Specific to this idea, not generic.
- **Reasoning / evidence** — 2-4 sentences. Cite analogous failed products if relevant. Name specific user segments, regulatory regimes, distribution channels, competitors, cost drivers, or timing forces — never just "the market" or "users."
- **Likelihood** — H / M / L. H = more likely than not. M = plausible. L = edge case but consequential.
- **Consequence** — H / M / L. H = kills the company / product line. M = forces a major pivot. L = costly but recoverable.
- **Cheapest falsification test (<1 week)** — a concrete action: e.g., "10 cold-outreach interviews with [segment] asking [exact question]", "Fermi-estimate CAC vs LTV on the back of an envelope using [public benchmark]", "search [public regulator/policy doc] for [keyword]", "build a fake-door landing page with [specific offer] and run $200 of ads to [channel]". Name the method.

## Phase 3 — Rank

Sort the 7 failure modes by severity, worst first. Use this scoring:

| Likelihood × Consequence | Score |
|---|---|
| H × H | 9 |
| H × M, M × H | 6 |
| H × L, L × H, M × M | 4 |
| M × L, L × M | 2 |
| L × L | 1 |

Break ties by listing the one with the cheapest/fastest falsification test first (test it first, learn fastest).

## Phase 4 — Write the report

Write to `idea-killer/reports/<slug>/kill-report.md`. Use this structure exactly:

```markdown
# Kill Report: <idea title>

> **Idea (as given):** <verbatim user input>
>
> **Restated:** <your 2-3 sentence restatement>
>
> **Inferred gaps:** <anything you had to infer, or "none">

## Top failure modes (worst first)

### 1. <Category>: <one-line failure mode>
- **Likelihood:** H/M/L
- **Consequence:** H/M/L
- **Score:** <n>
- **Reasoning:** <2-4 sentences, specific>
- **Cheapest test (<1 week):** <concrete method>

### 2. ...

(continue through all 7)

## The gate

You have just read 7 ways this idea dies. **If you ran every test above and addressed every failure mode that survived contact with evidence, would you fund this idea with your own money?**

- If YES → which 2 tests do you run this week?
- If NO → what would have to change about the idea — not the tests — for the answer to flip?
- If MAYBE → that is a NO with extra steps. Re-read the top 3.
```

## Phase 5 — Report back to the user

After writing the file, report in chat:

1. Absolute path to `kill-report.md`.
2. The top 3 failure modes by score, one line each.
3. The single cheapest test the PM should run *this week*.
4. The closing gate question, repeated verbatim. Do not answer it for them.

## Anti-patterns — do not do these

- Do not lead with "Great idea, here are some risks." Do not lead with praise at all.
- Do not say "this depends on execution" — that's a non-finding. Name the execution risk specifically.
- Do not propose tests that cost more than a week of PM time. If the only test is a 6-month pilot, the failure mode is unfalsifiable cheaply — say so explicitly.
- Do not skip a category because "this idea isn't regulated" or "team isn't relevant yet." Write the failure mode for why that assumption is itself the risk.
- Do not rank by gut. Use the L × C scoring grid.

## How this skill differs from adjacent skills

- **pm-deep-dive** — broad research and claim cross-validation. idea-killer is narrow, adversarial, and outputs a single ranked artifact. Run pm-deep-dive first to gather evidence; run idea-killer on the resulting recommendation.
- **protopilot** — builds the thing. idea-killer tries to talk you out of building it. Run idea-killer first; if the idea survives, protopilot it.
- **Generic SWOT or risk register** — those weight pros and cons equally and reward thoroughness. idea-killer only does the *cons*, demands falsification, and ranks ruthlessly.
