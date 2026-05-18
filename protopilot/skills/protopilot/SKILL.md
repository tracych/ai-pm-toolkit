---
name: protopilot
description: |
  Guided 4-phase skill that takes a PM from a problem statement to a self-contained, high-fidelity HTML prototype using Jobs-to-be-Done as the framing spine. Use when the user wants to: prototype an idea without writing code, turn a JTBD or problem brief into a clickable mock, scaffold a user flow + screens for stakeholder review, or produce a single-file HTML demo that's shareable and self-explainable. Triggers on language like "prototype this", "build a mock for X", "protopilot a checkout flow", "I have a JTBD, make it clickable", "turn this idea into an HTML demo".

  Do NOT trigger for: production frontend work (use a real frontend stack), Figma-fidelity visual design tasks, or research/strategy work where no artifact is needed (use pm-deep-dive instead).
---

# protopilot (skill)

Take a PM from problem → JTBD → flow → design → working HTML prototype, gating on user approval between phases. Output is one self-contained `prototype.html` (vanilla HTML/CSS/JS, zero CDN, opens anywhere) with an embedded "PM notes" overlay that makes the JTBD, flow, and design rationale legible to anyone who opens the file.

## Operating principles

- **Gated phases.** Do not advance to the next phase without explicit user approval. After each phase, summarize → ask "approve, refine, or restart this phase?".
- **JTBD is the spine.** Every later artifact must trace back to the job statement. If a screen or flow step doesn't serve the job, cut it.
- **High-fidelity but honest.** The prototype looks shippable but uses placeholder data clearly. Never imply real backend behavior — fake it visibly.
- **Self-explainable.** A non-author opening the HTML file should understand the JTBD, the flow, and why each screen exists — via a floating "PM notes" toggle, not a separate doc.
- **One file, zero dependencies.** Inline CSS, vanilla JS, no CDN, no build step. The deliverable is `prototype.html` — that's it.

## Phase 0 — Intake (one turn)

Ask the PM for a brief if they haven't already provided one. Minimum needed:

- **Problem / opportunity** — what's broken or unmet?
- **Who** — which user / persona / segment?
- **Context** — when/where does this come up for them?
- **Audience for the prototype** — internal review, leadership demo, user test?

If any of these is missing, ask in a single `AskUserQuestion` batch. Then derive a `<slug>` (kebab-case, 2-4 words) from the problem — this names the output folder.

## Phase 1 — Frame (JTBD)

Draft the job statement and supporting structure. Show the PM:

```
JOB STATEMENT
  When <situation>,
  I want to <motivation>,
  So I can <expected outcome>.

JOB EXECUTOR  <who is hiring this>
FUNCTIONAL DIMENSION  <what they need done>
EMOTIONAL DIMENSION   <how they want to feel / avoid feeling>
SOCIAL DIMENSION      <how they want to be perceived>
SUCCESS CRITERIA      <how they'll know it worked — 2-4 bullets>
CURRENT ALTERNATIVES  <what they hire today, and why it falls short>
```

Then ask: **approve, refine (specify what), or restart this phase?** Do not proceed without approval.

## Phase 2 — Flow

Derive the primary user flow from the approved JTBD. Show as a numbered list with decision points marked, plus an ASCII diagram for shape:

```
1. Entry  ─►  2. Step  ─►  3. Decision ─┬─► 4a. Success path
                                         └─► 4b. Recovery path
```

For each step name: the user's micro-goal, what they see, what they do next. Call out edge cases handled in v1 vs deferred. Keep to 3–7 primary steps.

Then ask: **approve, refine, or restart?** Do not proceed without approval.

## Phase 3 — Design

For each step in the approved flow, define one screen. Per screen:

- **Purpose** — which JTBD dimension it serves
- **Layout** — header / main / sidebar / footer regions, hierarchy
- **Components** — list (input, card, list, CTA, modal, etc.) with intended copy
- **Primary CTA** — one obvious next action
- **Empty / error / loading states** — if relevant to the demo

Also define overall **visual style**: color palette (3–5 hex codes), typography (system font stack), density, accent treatment. Aim for a polished, modern, neutral aesthetic unless the PM specifies otherwise.

Then ask: **approve, refine a specific screen, or restart?** Do not proceed without approval.

## Phase 4 — Build

Generate the prototype at `protopilot/prototypes/<slug>/prototype.html`. Requirements:

**Structure**
- Single `.html` file. All CSS in `<style>`, all JS in `<script>`. Zero external resources.
- Multi-screen via hash routing (`#/screen-name`) or a simple show/hide controller — whichever is cleaner.
- A persistent top nav or screen-switcher visible during demos so reviewers can jump around.

**Fidelity**
- High-fidelity styled mock: use the agreed palette, system font stack, real-looking copy, realistic placeholder data, icons via inline SVG (no icon CDN).
- Interactive: every CTA in the primary flow does something visible (advance screen, open modal, toggle state). Non-flow CTAs can be stubs that show a subtle "demo only" tooltip on click.
- Responsive enough to look good at laptop width; mobile-perfect is not required unless the JTBD demands it.

**Self-explainability — the "PM notes" overlay**
- A floating button (bottom-right) labeled "PM notes" toggles a side panel.
- Panel contains: the JTBD statement, the flow diagram, and per-screen rationale (which screen the viewer is currently on gets highlighted).
- Panel is keyboard-dismissible (Esc) and does not interfere with the prototype itself.

**Honesty markers**
- A small "PROTOTYPE — not connected to real data" pill in the top corner.
- Fake data should be clearly placeholder-y (Jane Doe, Acme Co.) — never realistic PII.

After writing the file, report:

1. Absolute path to `prototype.html`
2. How to open it (`open <path>` on Mac, `xdg-open` on Linux, double-click anywhere)
3. A 3-bullet "what's in v1 vs deferred" summary
4. Offer: iterate on any phase, or ship as-is.

## Iteration

When the PM comes back with "tweak the cart screen" / "change the CTA copy" / "redo the flow with a different entry point":

- Re-enter at the appropriate phase, carry forward approved artifacts from earlier phases, re-gate from that phase forward.
- Overwrite `prototype.html` in place. Do not version files by default; the PM can `cp` if they want to keep variants.

## How this skill differs from adjacent skills

- **pm-deep-dive** — strategy research; no artifact. protopilot produces a clickable artifact.
- **Generic codegen / web-builder skills** — start from a spec; protopilot starts from a *problem* and derives the spec via JTBD first.
- **Slide / doc generators** — produce static narrative; protopilot produces an interactive mock.
