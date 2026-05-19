# scoping-primer

Walk into the engineering scoping meeting already knowing the 12 questions you'll get hit with — and your best draft answers, with confidence flags marking what you still need to find out.

## What it does

Reads your feature/spec description, then drafts a single `scoping-primer.md` containing:

- A table of the 12 canonical engineering scoping questions
- Your best PM answer for each, drafted from the context you provided
- A confidence flag per row: **H** (you know), **M** (informed guess), **L** (guessing)
- An owner placeholder for every L (`<tech-lead>`, `<backend-eng>`, etc.) — who could validate
- A closing "Before the meeting, get answers for:" checklist of every L row

The 12 questions cover data shape, scale, latency, failure modes, auth, storage, migration, observability, rollback, dependencies, edge cases, and success metric — the ones engineers reliably ask in scoping.

## Use it

In Claude Code (with this repo in your workspace):

```
/scoping-primer self-serve refund flow for marketplace buyers, triggered from order detail page, must work for orders <90 days old
```

Or pass a path to a spec doc:

```
/scoping-primer ./specs/refund-flow.md
```

The skill refuses to run on briefs shorter than 15 words — ambiguous in = ambiguous out.

## Output

`scoping-primer.md` written to the current working directory. Open it, read it, then bring it (or the L-flagged checklist at the bottom) to the meeting.

## When NOT to use

- Post-meeting writeups — this is pre-meeting prep.
- Pure discovery / problem-validation — use `pm-deep-dive`.
- You haven't framed the feature at all yet — write a one-paragraph brief first.

## Operating principles

- **Every guess gets a flag.** No silently-confident hallucinations. L means "I'm guessing — go ask someone."
- **L rows get owners.** Each unknown names the role who could answer it, so the PM has a routing list, not just a worry list.
- **The L-list IS the meeting agenda.** If the table has 7 L's, those 7 questions are what the meeting is for. The H/M rows are context, not discussion.
- **Canonical order is fixed.** Engineers ask these in roughly this order; mirror that to make the doc skimmable in the room.
- **One file, no ceremony.** Markdown table, drop in a comment thread or paste into a doc.

## Composes with

Standalone. Pairs informally with `protopilot` — a built prototype is great source material for filling in data shape, flow, and edge-case rows with higher confidence. The L-flagged rows at the bottom make a ready-made agenda for the engineering scoping meeting itself.

## License

MIT.
