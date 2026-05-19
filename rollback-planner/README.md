# rollback-planner

Every launch needs an undo button. This makes you write it down *before* you ship.

## What it does

Walks a PM through an 8-question intake and emits two artifacts:

1. **`rollback-plan.md`** — the plan: blast radius, kill-switch, owners, numeric trigger thresholds, comms surfaces, dry-run cadence, plus pre-filled comms templates for internal / customer / exec audiences.
2. **`rollback-checklist.html`** — a single-file, offline, checkable list you can open in any browser. State persists in `localStorage`. Print-friendly.

The skill refuses vague answers where it matters. Question 6 (metric thresholds) will not accept "if things go bad" — you have to commit to a number for error rate, latency, and a business metric. Owners (question 4) are role placeholders only (`<launch-lead>`, `<oncall-engineer>`) so the artifact stays public-shareable.

## Use it

In Claude Code (with this repo in your workspace):

```
/rollback-planner shipping the new pricing page to 100% of US web traffic next Tuesday
```

Or describe the launch and let the skill auto-trigger on phrasing like "rollback plan for X", "what's our undo plan", "kill-switch for the launch".

If you skip the description, the skill will ask question 1 first and walk forward.

## Output

- `rollback-planner/plans/<slug>/rollback-plan.md`
- `rollback-planner/plans/<slug>/rollback-checklist.html`

Open the HTML by double-clicking. State persists per-browser via `localStorage`.

## When NOT to use

- Post-incident retro — use a retro template; the rollback already happened.
- Pure infra deploys with no user-facing surface — your deploy system already has revert; you don't need a comms plan.
- Reversible config tweaks behind an existing kill-switch with low blast radius — overkill.

## Operating principles

- **A number, not a vibe.** Every trigger threshold is a number. No "elevated errors" — `> 0.5% error rate over 10m`.
- **Roles, not names.** Owners are role placeholders. The artifact is public-friendly and survives team changes.
- **One page, one file.** The plan is markdown. The checklist is one HTML file with zero dependencies.
- **Rehearse once.** The dry-run cadence is a mandatory question. If you've never rolled it back in staging, you can't roll it back in prod.
- **Comms before postmortem.** Three audience-tuned templates (internal, customer, exec) are pre-filled. You don't draft comms during an incident.

## Composes with

- **premortem** — premortem's early-warning metrics feed directly into the metric thresholds here. Run premortem first to surface the failure modes; bring the numeric early-warning signals over as the question-6 triggers.
- **comms-pack** (future) — the three templates here are the seeds; comms-pack expands them into a full multi-stage comms pack once the rollback has actually fired.

## License

MIT.
