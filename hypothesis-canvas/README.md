# hypothesis-canvas

Convert a fuzzy idea into a falsifiable, A/B-ready hypothesis with a mandatory "abandon if" clause. Built for PMs who keep shipping pet features no one will ever kill.

## What it does

Takes a rough idea or change description and produces a single, structured hypothesis you can actually test:

> If we change **X** for **<segment>**, we expect **<metric>** to move by **<magnitude>** within **<window>**, because **<mechanism>**. We will abandon if **<abandon-if>**.

Six mandatory fields: `change`, `metric`, `magnitude`, `segment`, `mechanism`, `abandon-if`.

The `abandon-if` field is non-negotiable. If you can't name a concrete observable that would make you kill the work, the skill refuses to render the artifact and pushes back until you commit to one.

## Use it

In Claude Code (with this repo in your workspace):

```
/hypothesis-canvas add a streak counter to the home feed to lift D7 retention
```

Or just describe the change — the skill auto-triggers on phrasing like "frame this as a hypothesis", "make this A/B-ready", "what's the falsifier for X".

## Output

Three artifacts land in `hypothesis-canvas/canvases/<slug>/`:

- `hypothesis.html` — single-file editable canvas, opens offline, localStorage save, JSON export
- `hypothesis.md` — paste into docs / PRDs / experiment trackers
- `hypothesis.json` — machine-readable, for piping into other tools

## When NOT to use

- You already have a written hypothesis with a kill criterion — just ship it.
- Pure discovery / generative research — there's nothing to falsify yet.
- Roadmap or strategy framing — use `pm-deep-dive` to pressure-test the claim first.

## Operating principles

- **Falsifiable or it doesn't exist.** No abandon-if, no canvas. The skill refuses.
- **One change, one metric, one number.** If the hypothesis has two metrics, it's two hypotheses.
- **Numeric magnitude.** "Goes up" is not a magnitude. "+3pp D7 retention in 4 weeks" is.
- **Segment is mandatory.** "All users" is a smell. Name the cohort.
- **Mechanism in one sentence.** Why does this change move that metric for those users? If you can't say it, you're guessing.
- **Self-contained artifact.** The HTML opens with a double-click. No build, no CDN, no server.

## Composes with

- `assumption-tracker` — the conditions buried inside `abandon-if` are exactly the assumptions worth tracking over time. Pipe `hypothesis.json` straight in.
- `pm-deep-dive` — the `abandon-if` field is the falsifier `/pm-dive-frame` is asking for. Run a dive first if the claim isn't sharp yet.

## License

MIT.
