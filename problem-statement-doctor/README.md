# problem-statement-doctor

Score a draft problem statement on 8 rubrics, then rewrite it three ways so you can pick the framing that fits your audience.

## What it does

Takes a raw problem statement (a sentence, a paragraph, a Slack rant — whatever you've got) and runs it through a PM-flavored diagnostic:

1. **Scores** it 1–5 on 8 rubrics (specificity, user-centricity, measurability, falsifiability, scope, urgency, evidence quality, falsifiable success criteria) with a one-sentence rationale per dimension.
2. **Rewrites** it at three specificity levels — **broad** (executive framing), **focused** (team-ready), **surgical** (sprint-scoped) — annotated with the trade-offs.
3. **Recommends** which framing to use depending on who's reading it.

The output is one `problem-statement.md` in your working directory. Drop it in a PRD, paste it in a doc, or feed it to `/pm-dive-frame` as a cleaner seed.

## Use it

In Claude Code (with this repo in your workspace):

```
/problem-statement-doctor Users churn after the first week because onboarding is confusing
```

Or paste a longer draft into the conversation and let the skill auto-trigger on phrasing like "score my problem statement", "is this problem framing tight?", "rewrite this problem statement".

If your input is fewer than 10 words, the skill will refuse and ask you to elaborate — there's nothing to diagnose in a fragment.

## Output

`problem-statement.md` in your current working directory, containing:

- The original statement
- An 8-row scorecard table (rubric × score × rationale)
- Three rewrites (broad / focused / surgical) with trade-off annotations
- A short "pick the framing that fits your audience" guide

## When NOT to use

- You already have a tight, validated problem statement — just write the PRD.
- You need primary research to find the problem in the first place — use `pm-deep-dive`.
- You're prototyping a solution, not interrogating a problem — use `protopilot`.

## Operating principles

- **Diagnose before prescribing.** Score first, rewrite second. The scorecard is the receipts for the rewrites.
- **Three levels, not one "right answer."** A board memo and a sprint ticket need different framings of the same problem. Surface the trade-offs, let the PM pick.
- **Refuse fragments.** Under 10 words is not a problem statement — it's a vibe. The skill asks for more context instead of fabricating one.
- **No company-internal jargon.** Rewrites use plain language; if the input contains internal acronyms, the skill flags them as readability risks.

## Composes with

- **`/pm-deep-dive`** — run problem-statement-doctor first to clean up the seed claim, then hand the **focused** rewrite to `/pm-dive-frame` for orthogonal research angles.
- **`/protopilot`** — the **surgical** rewrite is a cleaner JTBD source for `/protopilot`'s Phase 1 frame.

## License

MIT. See repo root.
