---
name: scoping-primer
description: |
  Pre-engineering-meeting briefing skill. Takes a feature or spec description and produces a single scoping-primer.md containing the 12 canonical engineering scoping questions, the PM's best draft answer to each, an H/M/L confidence flag per row, and an owner placeholder for every L. Ends with a "Before the meeting, get answers for:" checklist of every L row. Use when the user wants to: prep for an engineering scoping or estimation meeting, anticipate the questions engineers will ask, audit a spec for gaps before sharing it, or turn a rough feature idea into a structured Q&A the eng team can review. Triggers on language like "prep me for scoping", "what will engineers ask about X", "scoping primer for this feature", "pre-meeting brief", "what am I missing in this spec".

  Do NOT trigger for: post-meeting writeups or retros, pure problem-discovery work (use pm-deep-dive), or production spec authoring where the PM already has all the answers (this skill is about surfacing what they DON'T know).
---

# scoping-primer (skill)

Take a feature description, produce `scoping-primer.md` in the cwd: a 12-row table of canonical engineering questions, PM-drafted answers, confidence flags, and owners for every unknown. The L-flagged rows at the bottom become the meeting agenda.

## Operating principles

- **Every guess gets a flag.** H = you know it cold. M = informed inference from the brief. L = you're guessing — flag it loudly so it can't masquerade as a decision.
- **L rows get owners.** Every L names a role (`<tech-lead>`, `<backend-eng>`, `<sre>`, `<security-reviewer>`, `<data-eng>`) who could validate. Use generic role names, never real people.
- **Canonical order, no skips.** All 12 questions appear, in the order defined in `assets/engineer_questions.md`. Engineers tend to ask in roughly this order — mirroring it makes the doc skimmable in the room.
- **One file, no ceremony.** Markdown only. Table + closing checklist. No preamble, no executive summary, no rationale section unless asked.

## Input contract

- `$ARGUMENTS` is either an inline feature description OR a relative/absolute path to a spec file.
- If it looks like a path that exists, read the file and use its content as the brief.
- Otherwise treat `$ARGUMENTS` itself as the brief.

## Length gate

Count words in the effective brief (after path expansion if applicable).

- **If fewer than 15 words:** do NOT write the file. Respond with a short message naming what's missing — at minimum, the user should describe: the feature (1 sentence), the user/trigger (1 sentence), and any known constraints (1 sentence). Ask them to re-run with more detail.
- **If 15+ words:** proceed.

## Step 1 — Load the canonical questions

Read `scoping-primer/assets/engineer_questions.md`. It contains the 12 questions, each with 2-3 sub-prompts to guide consistent answers. Use the sub-prompts to structure your draft answer per row — don't just answer the headline question.

## Step 2 — Draft answers

For each of the 12 questions, in order:

1. Read the sub-prompts.
2. Draft the PM's best answer based strictly on the provided brief plus reasonable PM defaults. Keep each answer to 1-3 sentences. Be concrete; if the brief is silent, say what you're assuming.
3. Assign a confidence flag:
   - **H** — explicitly stated in the brief OR a near-universal default no engineer would push back on.
   - **M** — reasonable inference from the brief; an engineer might refine but probably wouldn't reject.
   - **L** — you're guessing. The brief is silent and there's no safe default.
4. For every **L**, append an owner placeholder in angle brackets — the role who could validate. Common ones: `<tech-lead>`, `<backend-eng>`, `<frontend-eng>`, `<sre>`, `<security-reviewer>`, `<data-eng>`, `<infra>`, `<design>`, `<analytics>`.

When in doubt between M and L, choose L. Over-flagging is cheap; under-flagging hides risk.

## Step 3 — Write the file

Write `scoping-primer.md` to the current working directory. Structure exactly:

````markdown
# Scoping primer: <short feature name>

> Pre-meeting briefing. Draft answers to the questions engineers reliably ask in scoping. Flags: **H** you know, **M** informed guess, **L** guessing — needs validation.

| # | Question | Draft answer | Confidence | Owner if L |
|---|---|---|---|---|
| 1 | Data shape | <answer> | H/M/L | <role> |
| 2 | Scale | <answer> | H/M/L | <role> |
| ... | ... | ... | ... | ... |
| 12 | Success metric | <answer> | H/M/L | <role> |

---

## Before the meeting, get answers for:

- [ ] **Q<n> — <short question label>**: <one-line restatement of what you don't know> — ask `<role>`
- [ ] ...

(If no L rows exist: write `All 12 answered with H or M confidence. Walk into the meeting and confirm.`)
````

Rules for the table:
- Use the short question label as written in `assets/engineer_questions.md` (e.g. "Data shape", not the full sub-prompted question).
- Keep cells under ~30 words. If an answer is longer, summarize in the cell and add a short paragraph below the table under a `## Notes` heading.
- The "Owner if L" cell is blank (`—`) for H and M rows.
- The closing checklist includes EVERY L row — no exceptions. One checkbox per L.

## Step 4 — Report back

After writing, report:

1. Absolute path to `scoping-primer.md`.
2. Count of H / M / L flags (e.g. "3 H, 5 M, 4 L").
3. The L-row list inline (so the user can act on it immediately).
4. If L count is 6 or more, note that the brief is under-specified — suggest the user draft more context before the meeting or expect a long meeting.

## Iteration

When the user comes back with "the brief was actually X" or "we already decided Y for storage":

- Re-read the updated brief, re-run steps 2-3, overwrite `scoping-primer.md` in place.
- Don't version files. The user can `cp` if they want to keep variants.

## How this skill differs from adjacent skills

- **protopilot** — produces a clickable artifact from a problem. scoping-primer produces a Q&A briefing from a feature spec. A protopilot output is good *input* to scoping-primer.
- **pm-deep-dive** — open-ended strategy research. scoping-primer is bounded: exactly 12 questions, one file, ship it.
- **Generic spec templates** — fill in every section. scoping-primer's value is the H/M/L flagging and the L-list at the bottom — it surfaces what you DON'T know, not what you do.
