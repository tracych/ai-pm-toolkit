---
name: rollback-planner
description: |
  Eight-question intake skill that produces a rollback plan with numeric trigger thresholds, an explicit kill-switch, role-based owners, comms templates for three audiences, and a single-file HTML checklist with localStorage state. Use when the user wants to: plan a rollback before a launch, define kill-switch criteria, write down trigger thresholds, draft "we rolled it back" comms, or rehearse an undo plan. Triggers on language like "rollback plan for X", "what's our undo plan", "kill-switch for the launch", "pre-launch rollback intake", "we need rollback triggers".

  Do NOT trigger for: post-incident retros (the rollback already happened — use a retro template), pure infra deploys with no user surface, or reversible config flips behind a known kill-switch with negligible blast radius.
---

# rollback-planner (skill)

Walk a PM through 8 mandatory intake questions, then emit two artifacts: a markdown rollback plan and a single-file HTML checklist. The point is to force commitments — to numeric thresholds, to a named kill-switch, to a dry-run date — *before* launch, when the PM has time to think, instead of during an incident.

## Operating principles

- **A number, not a vibe.** Question 6 is the heart of the skill. If the PM gives a non-numeric answer for any of the three triggers, reject and re-ask. "Elevated errors" is not acceptable; `> 0.5% error rate over 10m` is.
- **Roles, not names.** Owners are role placeholders (`<launch-lead>`, `<oncall-engineer>`, `<comms-lead>`, `<exec-sponsor>`). The artifact must be public-shareable.
- **Best-draft-then-confirm.** For each question, draft the strongest answer you can infer from context, then show it to the PM and ask "confirm or edit?". Do not just ask cold.
- **One file per artifact.** Plan is markdown. Checklist is one HTML file with inline CSS, inline JS, zero CDN.
- **Honest about scope.** The checklist header carries a pill: "ROLLBACK CHECKLIST — fill before launch, rehearse once".

## Phase 0 — Slug + intake

From the launch description, derive a `<slug>` (kebab-case, 2–4 words) for the output folder: `rollback-planner/plans/<slug>/`.

Load the 8 questions from `assets/intake_questions.md`. Walk them in order.

## Phase 1 — Walk the 8 questions

For each question:

1. Draft a best-initial-answer from the launch description and any prior turns.
2. Show the PM:
   ```
   Q<n>. <question text>
   Draft answer: <your draft>
   ```
3. Ask: **confirm, edit, or skip with placeholder?**
4. Capture the confirmed answer. Move to the next question.

### Question-specific rules

- **Q4 (Owners).** If the PM offers a real name, replace with a role placeholder and explain: "this artifact is public-shareable; using `<launch-lead>` instead of a name keeps it durable across team changes."
- **Q6 (Metric thresholds).** Require three numeric triggers: error rate, latency, business metric. Each must include (a) a metric name, (b) a numeric threshold with units, (c) a duration window. If any of the three lacks a number, refuse and re-ask that specific trigger. Examples of acceptable:
  - `error rate > 0.5% sustained over 10 minutes`
  - `p95 latency > 800ms sustained over 5 minutes`
  - `checkout completion rate drops > 10% vs prior 7-day baseline over 30 minutes`
- **Q8 (Dry-run cadence).** At minimum, one rehearsal in a non-prod environment before launch. If the PM says "we'll skip the dry-run", note it as a flagged risk in the plan but do not block.

## Phase 2 — Emit the plan

Write `rollback-planner/plans/<slug>/rollback-plan.md` with this structure:

```
# Rollback plan — <launch name>

## 1. Change description
<answer>

## 2. Blast radius
<answer>

## 3. Kill-switch mechanism
<answer>

## 4. Owners
- DRI: <role-placeholder>
- Backup: <role-placeholder>
- Comms lead: <role-placeholder>

## 5. Dependencies
<answer>

## 6. Trigger thresholds (rollback fires if ANY of these trip)
- Error rate: <metric> <threshold> over <window>
- Latency: <metric> <threshold> over <window>
- Business metric: <metric> <threshold> over <window>

## 7. Comms surfaces (in order)
1. <first surface>
2. <second surface>
3. <third surface>

## 8. Dry-run cadence
<answer>

## Comms templates
<paste the three templates from comms_templates.md, with {{change_description}}, {{trigger_that_fired}}, {{status_link}} filled where possible>
```

## Phase 3 — Emit the checklist

Copy `assets/checklist_template.html` to `rollback-planner/plans/<slug>/rollback-checklist.html`. Replace the template's placeholder list items with concrete checklist steps derived from the plan. Default checklist items (rename/tailor based on the plan):

1. Confirm kill-switch is wired and tested in staging
2. Confirm DRI and backup are on-call window-aligned for launch
3. Confirm monitors are firing on all 3 trigger thresholds
4. Run dry-run rollback in non-prod
5. Pre-stage internal comms draft
6. Pre-stage customer comms draft
7. Confirm exec sponsor is reachable during launch window
8. Confirm dependencies have been notified (per question 5 list)
9. Confirm rollback playbook is linked in the on-call channel
10. Post-launch: leave checklist open for 24h, re-verify each item

Each `<li>` keeps the structure from the template: a checkbox with `id="step-N"` and a label.

## Phase 4 — Comms templates

Read `assets/comms_templates.md`. There are 3 templates: internal, customer, exec. Inline all three into the plan markdown under `## Comms templates`. Pre-fill the `{{change_description}}` placeholder using the answer from Q1. Leave `{{trigger_that_fired}}` and `{{status_link}}` as placeholders — these get filled at incident time, not now.

## Phase 5 — Report

After writing both files, report:

1. Absolute path to `rollback-plan.md`
2. Absolute path to `rollback-checklist.html`
3. The three numeric trigger thresholds, verbatim, so the PM can see them once more
4. A single-line callout if the PM opted out of dry-run
5. Offer: iterate on any question, or ship as-is.

## Iteration

When the PM comes back with "tighten the latency threshold" or "add a fourth comms surface":

- Re-enter at the relevant question, re-confirm, regenerate both files in place.
- Overwrite. Do not version. The PM can `cp` the folder if they want variants.
