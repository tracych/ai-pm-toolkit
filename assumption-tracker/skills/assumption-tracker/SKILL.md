---
name: assumption-tracker
description: |
  Extract every assumption from a PRD, spec, or strategy doc and classify each on a load-bearing × testable 2×2. Produces a top-5 "kill list" of the highest-priority assumptions to validate first, with the cheapest validation experiment proposed per assumption. Output is a self-contained interactive HTML file plus a machine-readable JSON. Use when the user wants to: surface hidden assumptions in a PRD, decide what to validate before building, pressure-test a strategy doc, build a risk register from a spec, or convert a roadmap into a falsifiable experiment plan. Triggers on language like "what am I assuming in this PRD", "list my assumptions", "what's load-bearing here", "what should I validate first", "track assumptions for this doc", "build a 2x2 of risks".

  Do NOT trigger for: pre-PRD brainstorms with no concrete claims (the doc has nothing to extract), post-launch retrospectives (use a premortem-style format instead), or when the user already knows the top risk and just wants to design one experiment (skip the extraction step and go straight to experiment design).
---

# assumption-tracker (skill)

Turn a PRD into a ranked kill list of assumptions. Every plan rides on beliefs the author hasn't separated from facts — this skill separates them, classifies them, and tells the PM which one to break first.

## Operating principles

- **Extract, don't invent.** Every assumption must trace to a specific line in the input doc. If you can't quote or closely paraphrase the source, drop it.
- **Load-bearing is binary.** If the plan still works when this assumption is wrong, it's not load-bearing. No "kind of" — force the call.
- **Testable means <2 weeks with on-hand resources.** A landing page test, a 5-user prompted task, a survey, a desk research pass, a competitive teardown. Not "we'd need to ship a beta."
- **Cheapest viable experiment.** Bias toward the smallest signal that would meaningfully shift confidence — not the most rigorous study.
- **Rank for blast radius.** The kill list is sorted by what would change the most about the plan if disconfirmed.
- **Honest fallback.** If the doc yields fewer than 3 assumptions, emit a flat markdown list and stop. Do not pad to fill a 2×2.

## Phase 1 — Intake

If `$ARGUMENTS` is a file path that exists, read it. If it's pasted text, use it as the doc. If empty, ask the user for a doc path or pasted content (single question).

Derive a `<slug>` (kebab-case, 2-4 words) from the doc title or topic. Create `assumption-tracker/output/<slug>/`.

## Phase 2 — Extraction

Scan the doc for assumption-shaped statements. Categories to look for:

- **User assumptions** — "users will...", "they want...", "people are willing to...", "the target segment cares about..."
- **Market assumptions** — "the market will...", "competitors won't...", "demand for X is growing...", "regulatory environment is..."
- **Engineering / technical assumptions** — "we can build...", "latency will be acceptable...", "this scales to...", "the model is accurate enough..."
- **Business / GTM assumptions** — "sales can sell this...", "support can handle volume...", "pricing of $X works...", "CAC will be under..."
- **Operational assumptions** — "the team has bandwidth...", "we get exec approval...", "partner X will integrate...", "data is available..."

Pull both explicit ("we assume…") and implicit (declarative claims stated as fact without evidence) assumptions. Aim for 5–20 — fewer is fine, more usually means you're splitting hairs. Each assumption is one crisp sentence in the PM's own framing, not a quote.

## Phase 3 — Classification

For each assumption, decide two binary questions:

1. **Load-bearing?** — Imagine this assumption is false. Does the core plan still work? If no → load-bearing = true.
2. **Testable in <2 weeks?** — Can you design an experiment that produces a meaningful confidence update inside two weeks with resources a PM can mobilize (small surveys, prompted user sessions, desk research, prototype tests, smoke tests, partner conversations)? If yes → testable = true.

The 2×2 quadrants:

- **Load-bearing + Testable** → KILL LIST candidates. Run experiments now.
- **Load-bearing + Not testable** → premortem candidates. Escalate, watchlist, build contingency.
- **Not load-bearing + Testable** → backlog. Nice to validate, low urgency.
- **Not load-bearing + Not testable** → ignore. Don't waste cycles.

## Phase 4 — Experiment design

For every assumption marked testable, write one **cheapest validation experiment** — one sentence, one paragraph max. Examples of cheap experiments:

- 5-person prompted user test with a paper sketch
- 30-response unbranded survey to a target segment
- Landing page + paid traffic smoke test (signup-rate as proxy)
- Desk research / 3 expert interviews
- Competitive teardown of the closest 2 alternatives
- 1-day technical spike to measure the unknown
- Sales team listening: ask 5 reps if customers ever ask for X
- Wizard-of-Oz pilot with 3 friendly customers

Pick the smallest experiment that would meaningfully move confidence. Note the rough effort (e.g. "~1 PM-day", "~3 days incl. recruiting") inline.

For assumptions marked not-testable, leave `experiment` as null or a short note ("not testable in <2wk — premortem").

## Phase 5 — Kill list

Pick the top 5 from the **load-bearing + testable** quadrant, ranked by blast radius (how much of the plan breaks if disconfirmed). If that quadrant has fewer than 5, fill the rest from load-bearing + not-testable and clearly mark them as "premortem, not test".

## Phase 6 — Render

**If total assumptions ≥ 3:**

1. Read `assumption-tracker/assets/template.html` as a string.
2. Replace the inline JSON placeholder (a `<script id="data" type="application/json">` block in the template) with the actual JSON payload:
   ```json
   {
     "title": "<doc title>",
     "slug": "<slug>",
     "killList": [{"text": "...", "experiment": "...", "rank": 1}, ...],
     "assumptions": [
       {"text": "...", "loadBearing": true, "testable": true, "experiment": "...", "source": "<quoted or paraphrased line>"}
     ]
   }
   ```
3. Write the prefilled file to `assumption-tracker/output/<slug>/assumptions.html`.
4. Write the same payload to `assumption-tracker/output/<slug>/assumptions.json`.

**If total assumptions < 3:**

Skip HTML. Write `assumption-tracker/output/<slug>/assumptions.md` with:

```
# Assumptions in <doc title>

Only N assumption(s) were extractable from this doc. Probably too early for a 2×2 — get to a fuller draft first.

1. <assumption> — load-bearing: yes/no, testable: yes/no. Source: "<line>". Experiment: <one line or n/a>.
2. ...
```

## Phase 7 — Report

After writing files, report to the user:

1. Absolute path to the output file(s).
2. How to open (`open <path>` / `xdg-open <path>` / double-click).
3. The top-5 kill list as a numbered list in the chat (so the PM gets the answer without opening the file).
4. The count of load-bearing-not-testable items as "premortem candidates" — flag these explicitly.
5. Offer: refine an experiment, re-classify a specific assumption, or compose into `pm-deep-dive` / `premortem`.

## Iteration

When the PM comes back with "the engineering assumption isn't load-bearing, demote it" / "add this one I forgot" / "the experiment for #2 is too expensive, propose something cheaper":

- Re-run only the relevant phase. Carry forward the rest of the JSON.
- Overwrite `assumptions.html` and `assumptions.json` in place.

## How this skill differs from adjacent skills

- **pm-deep-dive** — investigates one falsifiable claim deeply. assumption-tracker surfaces *which* claim to investigate.
- **premortem** — assumes failure and works backward. assumption-tracker partitions risks into "test now" vs "premortem material".
- **protopilot** — builds the artifact. assumption-tracker decides if the artifact's premises hold before you build.
