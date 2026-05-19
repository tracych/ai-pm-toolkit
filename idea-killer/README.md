# idea-killer

Adversarial steel-man-the-no: the 7 strongest reasons your idea will fail, ranked, each with the cheapest test that could kill it this week.

## What it does

Generates a `kill-report.md` for a product idea by forcing coverage of all 7 categories every serious product fails on:

1. **Demand** — does anyone actually want this?
2. **Distribution** — can you reach them affordably?
3. **Competition** — who eats your lunch, including substitutes and "do nothing"?
4. **Regulation** — what laws, policies, or platform rules can shut this down?
5. **Unit economics** — does the math work at scale?
6. **Organization / team** — can this team actually ship and operate it?
7. **Timing** — why now? why not 2 years ago? why not 2 years from now?

For each, the skill writes a failure mode, scores likelihood (H/M/L) and consequence (H/M/L), proposes the **cheapest falsification test a PM can run in under a week**, and ranks the seven by severity. It closes with a fund-or-not gate: *if you addressed all 7, would you write the check?*

It is explicitly built to counter sycophancy. It is not here to find the bright side.

## Use it

In Claude Code (with this repo in your workspace):

```
/idea-killer An AI assistant that drafts performance reviews for engineering managers based on six months of code review and PR activity.
```

If the idea is fewer than 10 words, the skill refuses and asks you to elaborate. Vague ideas produce vague autopsies.

## Output

A single `idea-killer/reports/<slug>/kill-report.md` containing:

- The idea verbatim
- 7 failure modes, sorted by likelihood × consequence (worst first)
- Per failure mode: evidence/reasoning, likelihood, consequence, cheapest falsification test (<1 week, named tool or method)
- A closing "fund-or-not" gate

## When NOT to use

- You want validation, encouragement, or a pitch deck — wrong tool.
- You haven't framed the idea at all — write 2 sentences first.
- You need quantitative market sizing — use a research skill; this is qualitative pre-mortem.
- The idea is already in production and you need a post-mortem — different artifact.

## Operating principles

- **All 7, every time.** No skipping categories because "this one doesn't apply." Force the question.
- **Falsification > opinion.** Each failure mode ships with a test cheaper than a week of PM time. If you can't think of a test, the failure mode is too vague — rewrite it.
- **Rank ruthlessly.** Likelihood × consequence. Don't bury the lede.
- **No sycophancy.** No "this is a great idea, but…". No bright-siding. The job is to kill it; if it survives, that's the signal.
- **Specific over generic.** "Users won't pay" is useless. "SMB owners under $1M revenue historically churn on tools >$30/mo with no immediate ROI" is useful.

## Composes with

- **pm-deep-dive** — after a deep-dive lands a claim verdict, run idea-killer on the resulting recommendation as a final adversarial pass before shipping the doc.
- **hypothesis-canvas** — the 7 failure modes become the explicit *abandon-if* conditions on the hypothesis canvas.
- **protopilot** — kill the idea first; if it survives, prototype it.

## License

MIT.
