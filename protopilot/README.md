# protopilot

Turn a problem statement into a clickable, self-explainable HTML prototype — without writing code. Built for PMs.

## What it does

Guides you through four gated phases, asking for approval at each step:

1. **Frame** — derive a Jobs-to-be-Done statement from your problem brief
2. **Flow** — map the primary user flow that serves the job
3. **Design** — define screens, components, copy, and visual style
4. **Build** — generate one self-contained `prototype.html` (vanilla HTML/CSS/JS, zero CDN)

The output is a single file you can email, drop in Slack, or open with a double-click. A floating "PM notes" panel inside the prototype explains the JTBD, flow, and per-screen rationale to anyone who opens it.

## Use it

In Claude Code (with this repo in your workspace):

```
/protopilot a self-serve onboarding flow for first-time creators on our marketplace
```

Or just describe what you want — the skill auto-triggers on phrasing like "prototype this", "build a mock for X", "turn this idea into an HTML demo".

If you skip the brief, protopilot will ask the four intake questions first (problem, who, context, audience).

## Output

Prototypes land in `protopilot/prototypes/<slug>/prototype.html`. Open in any browser — no server, no install.

## When NOT to use

- Production frontend work — use a real stack.
- Pixel-perfect visual design — use Figma.
- Pure strategy/research with no artifact — use `pm-deep-dive`.

## Conventions

- High-fidelity styled mock by default (not wireframe).
- Honest about being a prototype: visible "PROTOTYPE" pill, obviously fake data.
- Self-contained: zero external dependencies, opens offline.
- One file per prototype. Iterate by overwriting; `cp` if you want variants.
