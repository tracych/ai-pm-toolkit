# retro-facilitator

Run a real post-launch retro in 30 minutes, ship a writeup, and quietly build a local archive of every launch lesson you've ever captured.

## What it does

Walks you through a fixed 5-step retro agenda, gating at each step:

1. **What shipped** — 1-paragraph summary + links to source artifacts
2. **What worked** — 3–5 bullets, each tied to a specific decision or practice
3. **What surprised us** — 3–5 neutral facts, no blame
4. **What we'd do differently** — 3–5 bullets, each paired with reasoning
5. **Action items** — every item needs an owner placeholder *and* a due date, or the skill refuses to finalize

Then it writes the retro to `retros/retro-<YYYY-MM-DD>-<slug>.md` and appends a row to `retros/index.html` — a single-file, sortable, offline-viewable archive of every retro you've run.

## Use it

In Claude Code (with this repo in your workspace):

```
/retro-facilitator creator-onboarding-v2 week-1
```

Args: launch slug, optional `week-1` or `month-1` marker. The skill also auto-triggers on phrasing like "let's retro the launch", "run a post-launch retro on X".

## Output

- `retros/retro-<YYYY-MM-DD>-<slug>.md` — the writeup itself
- `retros/index.html` — append-only local archive, sortable by date, opens offline, zero CDN

## When NOT to use

- Mid-launch debugging — use an incident review, not a retro.
- Personal performance feedback — wrong format, wrong audience.
- Roadmap planning — retros look backward; use a planning ritual instead.

## Operating principles

- **Fixed agenda, no skipping.** The 5 steps run in order. You can refine a step, not delete it.
- **Owners + due dates are non-negotiable.** Action items without both are how retros die. The skill enforces it.
- **Role placeholders, not names.** Owners are `<launch-lead>`, `<eng-lead>`, etc. — keeps the archive shareable and prevents drift when people rotate.
- **Local archive is the asset.** One markdown writeup is fine; 30 of them indexed in one HTML file is a pattern-matching engine for your future launches.
- **Append-only, no external sync.** Your retros stay on your disk. No SaaS, no login.

## Composes with

- **comms-pack** — closes the launch loop: comms-pack ships the launch comms, retro-facilitator captures what we learned after.
- **premortem** — compare retro learnings against the original premortem stories to validate or kill archetypes.
- **future launch-portfolio tools** — the local archive is the substrate for cross-launch pattern matching.

## License

MIT. See repo root.
