---
name: premortem
description: |
  Adversarial planning skill that takes a feature or launch description and produces five dated, post-failure narratives — one per canonical archetype (adoption-flop, trust-incident, abuse-vector, performance-regression, internal-politics) — each with a causal chain and a numeric early-warning metric the PM can instrument before launch. Use when the user wants to: pressure-test a launch plan, run a premortem or red-team exercise, surface failure modes before shipping, generate rollback trigger conditions, or stress-test a strategy doc with an adversarial pass. Triggers on language like "premortem this", "what could go wrong with X", "red-team this launch", "pre-mortem the rollout", "stress-test this plan", "how does this fail".

  Do NOT trigger for: happy-path narrative or launch comms drafts (use a writing skill), open-ended strategy research where no decision is yet framed (use pm-deep-dive), or post-launch retros where the failure has already happened (use a retro template, not this skill).
---

# premortem (skill)

Force five distinct failure futures into the open before the launch ships. Each future is a dated narrative + causal chain + instrumentable early-warning metric, so the PM leaves with actionable thresholds rather than vague anxiety.

## Operating principles

- **Five archetypes, always.** Adoption-flop, trust-incident, abuse-vector, performance-regression, internal-politics — in that order. If an archetype genuinely doesn't apply, the story says so explicitly and explains why. Never silently skip.
- **Dated, past-tense narratives.** Write each story as if it has already happened, dated 6–12 months from today. Concrete week, concrete user segment, concrete trigger event.
- **Causal chain required.** Every story names 3–5 linked events from a leading indicator → the visible failure. No "and then somehow it failed."
- **Instrumentable today.** The early-warning metric must be measurable *before* the feature ships, using data the PM already has access to or can request now. If it can only be measured post-launch, it's the wrong metric.
- **Numeric threshold, not vibes.** "If <metric> crosses <value> by <week>" — never "if it feels off."
- **Specific to this launch.** Generic platitudes that would apply to any launch are a failure mode. Reject and redraft if a story could be copy-pasted to a different brief.

## Phase 0 — Validate the brief

Count words in the launch description (whitespace-split). If fewer than 12, do not proceed. Respond:

> The brief is too thin to write useful failure stories. I need at least: (1) what's shipping, (2) which user segment, (3) the surface or context it appears in, and (4) the intended outcome. Please expand and re-run.

Ask the PM to expand. Do not generate anything until you have a brief that clears the threshold.

## Phase 1 — Load archetypes

Read `assets/archetypes.md` from this skill's plugin directory. For each archetype, you'll use the definition to anchor the narrative and the prompting questions to derive the causal chain and metric. Do not invent additional archetypes; do not reorder them.

## Phase 2 — Generate the five stories

For each archetype, in canonical order, produce a section in `premortem.md`:

```
## <archetype-name>

**Failure date:** <Month YYYY, 6–12 months from today's date>
**One-line summary:** <≤ 20 words, the headline a PM would tell their skip-level>

**Narrative.** <One paragraph, past tense, dated. Names the user segment, the surface, the trigger event, and the visible consequence. 4–7 sentences.>

**Causal chain.**
1. <Leading indicator — observable before launch or in the first weeks>
2. <Intermediate event>
3. <Intermediate event>
4. <Visible failure>
(3–5 steps; each step must be a concrete event, not an abstraction.)

**Early-warning metric.** <Name of a single numeric metric the PM could instrument today.>
**Threshold.** <If <metric> crosses <numeric value> by <specific week / cohort>, treat as a fire signal.>
**How to instrument today.** <One sentence: which existing data source, log, survey, or tracking event already contains this, or what minimal addition is needed.>
**Owner (placeholder).** <Role title, e.g. "Launch PM", "Trust eng lead", "Partner team PM" — leave as a role placeholder; the PM fills in a name.>
```

Quality bar per story:
- Narrative names a specific user segment from the brief, not "users."
- Causal chain steps are events with verbs, not states.
- Metric is numeric and measurable today.
- Threshold has both a number and a time/cohort qualifier.

## Phase 3 — Summary table

End the file with a single table:

```
## Summary

| archetype | story | early-warning metric | threshold | owner |
|---|---|---|---|---|
| adoption-flop | <one-line summary> | <metric> | <threshold> | <role placeholder> |
| trust-incident | ... | ... | ... | ... |
| abuse-vector | ... | ... | ... | ... |
| performance-regression | ... | ... | ... | ... |
| internal-politics | ... | ... | ... | ... |
```

Keep each cell to one line for scannability.

## Phase 4 — Write and report

Write the full output to `premortem.md` in the current working directory. Then report to the PM:

1. Path to the written file.
2. Which 1–2 stories you think deserve the most attention this week, and why (your call, not a hedge).
3. Offer: refine a specific archetype, raise the bar on a weak metric, or hand the table off to `rollback-planner` when that tool is available.

## Iteration

When the PM pushes back ("the abuse-vector story is generic" / "make the adoption metric tighter"):

- Re-enter at the specific archetype, keep the other four untouched, and rewrite that section in place.
- Update the summary table row to match.
- Do not version the file by default — overwrite. The PM can `cp` if they want to keep variants.

## How this skill differs from adjacent skills

- **pm-deep-dive** — investigates whether a claim is true. premortem assumes the launch ships and asks how it dies.
- **protopilot** — produces a clickable artifact. premortem produces an adversarial document.
- **Generic risk-register templates** — list risks in the abstract. premortem forces dated narratives with causal chains and numeric thresholds.
