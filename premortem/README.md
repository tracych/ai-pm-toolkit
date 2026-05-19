# premortem

Simulate 5 distinct futures where your launch failed — each with a causal chain and an early-warning metric you can instrument today.

## What it does

Takes a feature or launch description and produces `premortem.md` with five dated, post-failure narratives — one per archetype, always in this order:

1. **adoption-flop** — users shrugged
2. **trust-incident** — something broke a promise
3. **abuse-vector** — bad actors found a use you didn't intend
4. **performance-regression** — it shipped, then degraded the surface around it
5. **internal-politics** — the org killed it before users did

Each story is a 1-paragraph narrative dated 6–12 months out, traced backward through a causal chain to a numeric early-warning metric and threshold the PM can wire up before launch. The file ends with a summary table: archetype, one-line story, metric, threshold, owner.

## Use it

In Claude Code (with this repo in your workspace):

```
/premortem launching in-product weekly digest emails for SMB admins to recover dormant teams
```

Or describe the launch and let the skill auto-trigger on phrasing like "premortem this", "what could go wrong with X", "pressure-test this launch".

The skill refuses to run on briefs shorter than 12 words and asks for more context — failure modes are only useful if grounded in specifics.

## Output

`premortem.md` written next to where you ran the command. Five archetype sections + a summary table at the end. Drop it in your launch doc, your risk review, or your rollback planning.

## When NOT to use

- You haven't framed the launch yet — use `pm-deep-dive` first.
- You don't have a designed artifact to stress-test — use `protopilot` first.
- You want a happy-path narrative or comms draft — this tool is adversarial by design.
- The decision is already made and you want validation — premortem will tell you uncomfortable things.

## Operating principles

- **Five stories, always.** No skipping archetypes because "that one doesn't apply." If it truly doesn't, the story will say so explicitly — that's a signal, not a skip.
- **Dated futures, not abstractions.** Each narrative is written as if it already happened, 6–12 months from today.
- **Causal chain or it didn't happen.** Every failure traces back through 3–5 linked events to a leading indicator.
- **Instrumentable today.** Every early-warning metric must be measurable before the launch ships, not after.
- **Numeric thresholds.** "If X crosses Y by week Z" — not "if it feels wrong."

## Composes with

- **pm-deep-dive** — run premortem as an adversarial pass *before* finalizing the strategy doc. Findings here often invalidate prior HIGH-confidence claims.
- **protopilot** — run premortem *after* you have a prototype, to pressure-test the actual designed behavior, not the imagined one.
- **rollback-planner** — the early-warning metrics and thresholds produced here feed directly into rollback trigger conditions.

## License

MIT
