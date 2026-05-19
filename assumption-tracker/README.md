# assumption-tracker

Every PRD is a stack of assumptions wearing a trench coat. This tool pulls them apart and ranks which ones to kill first.

## What it does

Reads a PRD, spec, or strategy doc and:

1. **Extracts** every implicit and explicit assumption (claims about users, market, engineering, ops).
2. **Classifies** each on a 2×2: **load-bearing** (does the plan collapse if wrong?) × **testable** (can we validate in <2 weeks?).
3. **Proposes** the cheapest validation experiment per testable assumption.
4. **Ranks** a top-5 kill list — the assumptions whose disconfirmation would save the most time.
5. **Renders** an interactive single-file `assumptions.html` with the 2×2, click-to-expand cells, and the kill list pinned to the top.

## Use it

In Claude Code (with this repo in your workspace):

```
/assumption-tracker path/to/prd.md
```

Or paste the doc text:

```
/assumption-tracker
<paste PRD here>
```

The skill also auto-triggers on phrasing like "what am I assuming in this PRD", "list my assumptions", "what's load-bearing here".

## Output

- `assumption-tracker/output/<slug>/assumptions.html` — interactive 2×2 + kill list, opens offline.
- `assumption-tracker/output/<slug>/assumptions.json` — machine-readable list for piping into other tools.
- If fewer than 3 assumptions are extractable, you get `assumptions.md` (flat list) instead — don't dress up thin signal as analysis.

## When NOT to use

- Doc has no claims yet (pre-PRD brainstorm) — get to a draft first.
- You already know your top risks and just need to validate one — go run the experiment.
- Post-launch retrospective — use a premortem-style format, not a 2×2.

## Operating principles

- **Load-bearing is binary on purpose.** If you find yourself hedging, the assumption is load-bearing.
- **Testable means <2 weeks with on-hand resources.** Anything longer is a roadmap item, not a test.
- **Cheapest experiment, not best.** A 30-person survey beats a perfect study you never run.
- **Rank ruthlessly.** The kill list is 5 items — not 12. If everything is critical, nothing is.
- **Untestable + load-bearing = premortem candidate.** Flag it, escalate it, don't pretend you'll test it.

## Composes with

- `pm-deep-dive` — once the kill list is set, each load-bearing assumption becomes a falsifiable claim for `/pm-dive-frame` to investigate in depth.
- `premortem` — every load-bearing assumption that is NOT testable belongs in the premortem; you can't run an experiment, so you have to imagine the failure.

## License

MIT. See repo root.
