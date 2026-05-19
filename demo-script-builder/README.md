# demo-script-builder

Audience-aware 5-minute demo script with stage directions, a wow moment, and three pre-rebutted questions — generated from a one-line feature description.

## What it does

Takes a feature description and an audience flag (`exec`, `customer`, or `engineer`) and writes one `demo-<audience>.md` file containing:

- A 30-second elevator at the top (stands alone)
- A 5-minute script broken into Hook / Setup / Walkthrough / Wow / Close, with explicit stage directions in italics
- A clearly labeled `## WOW MOMENT` with a 1-line rationale for why it lands
- A Q&A appendix with the three most likely audience-specific questions and crisp pre-rebuttals

The framing changes per audience: execs hear business impact, customers hear outcome, engineers hear mechanism. Same feature, three different stories.

## Use it

In Claude Code (with this repo in your workspace), pass the feature and an audience flag:

```
/demo-script-builder our new bulk-edit dashboard --audience exec
/demo-script-builder our new bulk-edit dashboard --audience customer
/demo-script-builder our new bulk-edit dashboard --audience engineer
```

If you omit the audience flag, or pass anything other than `exec` / `customer` / `engineer`, the skill will ask. It will not invent a fourth audience.

## Output

One file per run: `demo-<audience>.md` in the current working directory. Markdown, copy-pastable, designed to be read from in front of a real audience or rehearsed alone.

## When NOT to use

- You don't have a working thing to demo yet — use `protopilot` first to build the artifact.
- You want a written narrative for async distribution — use `comms-pack`, not a script.
- The audience isn't one of exec / customer / engineer — refine your audience before scripting.

## Operating principles

- **Audience-first framing.** Each audience gets its own opinionated profile (`assets/audience_profiles.md`). The skill loads the profile and rewrites every section through that lens.
- **Time-boxed structure.** 30s + 60s + 180s + 30s + 30s = 300s. The script is annotated with target times; if you can't hit them, the feature is too big for one demo.
- **Stage directions are mandatory.** Every section has italicized direction (`*Open the dashboard. Hover the badge until the tooltip appears.*`) so a colleague could run the demo from the script.
- **One wow moment, clearly labeled.** Demos that try to wow three times wow zero times.
- **Pre-rebut, don't dodge.** The Q&A appendix surfaces the three hardest likely questions and answers them honestly up front.

## Composes with

- **`protopilot`** — build the clickable artifact first, then use its PM notes as the source brief for the demo script.
- **`comms-pack`** — the demo script is the spoken-word sibling of comms-pack's written artifacts; pair them for a launch.

## License

MIT (see repo root).
