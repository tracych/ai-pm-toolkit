---
name: demo-script-builder
description: |
  Generate a 5-minute, audience-tuned live demo script for a feature, with explicit stage directions, one clearly labeled wow moment, and a Q&A appendix of three pre-rebutted likely questions. Use when a PM needs to: rehearse or run a live demo, prep a launch readout for execs, walk a customer through a new capability, or hand engineers a credible technical walkthrough. Triggers on language like "write me a demo script", "I'm demoing X to leadership", "script a customer walkthrough of Y", "give me a 5-minute pitch for this feature".

  Do NOT trigger for: written async announcements (use comms-pack), building the artifact being demoed (use protopilot), strategy decks or long-form narratives, or any audience outside {exec, customer, engineer} — refuse and ask the user to pick one.
---

# demo-script-builder (skill)

Turn a one-line feature description + an audience flag into a single `demo-<audience>.md` file containing a 30-second elevator and a tightly-timed 5-minute live demo script with stage directions, a labeled wow moment, and three pre-rebutted likely questions.

## Operating principles

- **Audience drives everything.** Execs care about business impact (cost, revenue, risk). Customers care about outcome (job done, time saved, frustration removed). Engineers care about mechanism (architecture, data flow, edge cases). Never blur these.
- **Time-boxed.** Total runtime is 300 seconds. If the feature can't fit, ship a tighter slice — don't sprawl past 5 minutes.
- **Stage directions are mandatory.** Every section has italicized direction so another PM could run the demo cold from the script.
- **One wow moment.** Multiple "wows" cancel each other out. Pick the single most surprising or delightful beat and label it.
- **Pre-rebut the hard ones.** The Q&A appendix is for the three questions you're most afraid of, with crisp honest answers — not softballs.
- **Refuse invalid audience.** Only `exec`, `customer`, `engineer` are valid. If the user passes anything else, ask them to pick one. Do not invent a fourth profile.

## Phase 0 — Validate inputs

Parse `$ARGUMENTS` for:

1. A feature description (free text).
2. An `--audience` flag with value `exec`, `customer`, or `engineer`.

If the audience flag is missing or invalid:

> "I need an audience to tune the script. Pick one: `exec`, `customer`, or `engineer`. (These are the only three profiles — they map to business impact, outcome, and mechanism framing respectively.)"

Do not proceed without a valid audience. Do not infer one from context.

If the feature description is missing or too thin (< ~6 words), ask one batched question: what is the feature, who is it for, what's the single most impressive thing it does?

## Phase 1 — Load audience profile

Read `demo-script-builder/assets/audience_profiles.md` and locate the section matching the chosen audience (`## exec`, `## customer`, or `## engineer`). Extract:

- The 3-5 framing rules
- The 3 common objection types to pre-rebut

These drive every section of the output. Do not paraphrase the rules — apply them.

## Phase 2 — Draft the script

Structure (target seconds in parens, total 300s):

1. **Hook (30s)** — Open with a sharp line that lands the *audience-specific* stake. For exec: a number or risk. For customer: a frustration they recognize. For engineer: a constraint that was hard.
2. **Setup (60s)** — Frame the problem and the before-state. One sentence on context, one on who has the problem, one on why now.
3. **Walkthrough (180s)** — The live tour. 3-5 beats, each with a stage direction in italics. Each beat answers: what does the audience see, what does it mean for them.
4. **Wow moment (30s)** — Labeled `## WOW MOMENT`. The single most surprising / delightful / disproportionate-effort-to-payoff thing. One line of rationale beneath it explaining why this lands *for this audience*.
5. **Close (30s)** — Restate the value in the audience's language. Ask for the specific thing you need from them (decision, feedback, signup, code review — match the audience).

Every section must contain at least one italicized stage direction: `*Open the dashboard. Click the third row. Wait for the badge to render.*`

## Phase 3 — 30-second elevator

Write a standalone 30-second elevator pitch at the top of the file (under a `## 30-second elevator` heading) that someone could read aloud verbatim if the full demo gets cut. Use the audience's framing — same lens as the main script.

## Phase 4 — Q&A appendix

Under `## Q&A appendix`, list the three audience-specific objection types from the profile. For each:

- **Q:** State the likely question in the audience's own words (sharp, not strawman).
- **A:** A 2-4 sentence honest pre-rebuttal. Acknowledge the legitimate concern, then answer. If the honest answer is "we don't know yet", say so and add what would change the answer.

## Phase 5 — Write the file

Write `demo-<audience>.md` to the current working directory. File structure:

```
# Demo — <feature one-liner>  (audience: <audience>)

## 30-second elevator
<standalone pitch>

## Full script (~5 minutes)

### Hook — 30s
*<stage direction>*
<spoken script>

### Setup — 60s
*<stage direction>*
<spoken script>

### Walkthrough — 180s
*<stage direction>*
Beat 1: ...
Beat 2: ...
Beat 3: ...

## WOW MOMENT — 30s
*<stage direction>*
<the moment>

_Why this lands:_ <one line>

### Close — 30s
*<stage direction>*
<spoken script + ask>

## Q&A appendix

**Q1:** ...
**A:** ...

**Q2:** ...
**A:** ...

**Q3:** ...
**A:** ...
```

After writing, report:

1. Absolute path to the file.
2. Total estimated runtime.
3. One sentence on the chosen wow moment.
4. Offer: regenerate for a different audience, tighten a specific section, or ship as-is.

## Iteration

When the PM comes back with "make it sharper for the CFO" / "the wow moment is weak" / "add a fourth Q":

- If the audience changes, re-run from Phase 1 with the new profile and overwrite a new `demo-<new-audience>.md` (do not overwrite the prior file — keep both).
- If they want a section tightened, edit in place and re-report.
- Never expand past 5 minutes total. If they want more, suggest splitting into two demos.

## How this skill differs from adjacent skills

- **comms-pack** — produces written async artifacts; this produces a spoken-word script.
- **protopilot** — produces the artifact you'd demo; this scripts the demo of it.
- **pm-deep-dive** — strategy research with no performance artifact; this is purely performance prep.
