---
name: retro-facilitator
description: |
  Guided 5-step skill that walks a PM through a fixed post-launch retro agenda (what shipped, what worked, what surprised us, what we'd do differently, action items), produces a markdown writeup, and appends a row to a local rolling HTML archive of every retro ever run. Use when the user wants to: run a post-launch retro, debrief a shipped feature with structure, capture lessons from a launch into a shareable writeup, or build a longitudinal archive of launch learnings. Triggers on language like "run a retro on X", "let's retro the launch", "post-launch debrief for X", "retro-facilitator week-1 of <launch>", "capture lessons from <launch>".

  Do NOT trigger for: mid-launch incident reviews (different format — use an incident review template), personal performance feedback (wrong audience), roadmap or planning rituals (these look forward, retros look back), or one-off "what should we do next" brainstorming (use a planning ritual instead).
---

# retro-facilitator (skill)

Walk a PM through a fixed 5-step post-launch retro, gate at each step, and ship two artifacts: a markdown writeup of this retro and a new row in a local sortable HTML archive of every retro the PM has ever run.

## Operating principles

- **Fixed agenda, fixed order.** The 5 steps in `assets/agenda.md` run in sequence. The user can refine a step or restart the current step — they cannot skip one or reorder them.
- **Gate between every step.** After each step, summarize what was captured and ask: **approve, refine (specify what), or restart this step?** Do not advance without explicit approval.
- **Owners + due dates are non-negotiable.** In step 5, every action item must have an owner placeholder (`<role>`) AND a due date. If any item is missing either, REFUSE to finalize and ask the PM to fix or drop those items.
- **Role placeholders, never names.** Owners are `<launch-lead>`, `<eng-lead>`, `<design-lead>`, `<data-lead>`, etc. Never write a real human name into the writeup or the archive.
- **Local-only, append-only.** All artifacts live under `retros/` in the repo. Never sync, upload, or post externally. The header pill in the archive makes this contract visible.

## Phase 0 — Intake

Parse `$ARGUMENTS`. Expected shape:

```
<launch-slug> [week-1|month-1]
```

- `<launch-slug>` — kebab-case, required. Used in the output filename and the archive row.
- `week-1` or `month-1` — optional marker for how far past launch we are. If omitted, ask the PM once and accept either marker or "other" (free-text, short).

If the slug is missing, ask for it in one turn before proceeding. Then compute today's date by running `date +%Y-%m-%d` (ISO format, never freehand).

## Phase 1 — Walk the agenda

Read `assets/agenda.md` and run each of the 5 steps in order. For every step:

1. Present the step's intent and the format constraints (bullet count, paired reasoning, owner+date requirement, etc.).
2. Elicit content from the PM. If the PM dumps a long brain-dump, structure it into the required format and show the result.
3. Summarize what was captured.
4. Ask: **approve, refine (specify what), or restart this step?**
5. Only advance on `approve`.

### Step-specific constraints

- **Step 1 (What shipped)** — exactly one paragraph; include 1–4 links to source artifacts (PRD, launch post, dashboard, comms thread). If the PM has no links, leave a `[link TBD]` placeholder rather than skipping.
- **Step 2 (What worked)** — 3–5 bullets, each anchored to a *specific decision or practice*. Reject vague compliments ("team was great"); push for the underlying mechanism.
- **Step 3 (What surprised us)** — 3–5 bullets, neutral facts only, framed as "We expected X, we saw Y." No blame, no "should haves" — those belong in step 4.
- **Step 4 (What we'd do differently)** — 3–5 bullets, each paired with reasoning ("…because this would have caught Y earlier"). Forward-looking, not punitive.
- **Step 5 (Action items)** — concrete next steps. Format: `- [ ] <action> — owner: <role>, due: <YYYY-MM-DD or relative>`. Before finalizing, scan every item:
  - If any item lacks an owner placeholder, REFUSE to finalize. Tell the PM which item(s) and ask them to add an owner or drop the item.
  - If any item lacks a due date, REFUSE to finalize. Same drill.
  - Placeholders are fine (`<launch-lead>`, `<TBD-owner>`); empty is not.

## Phase 2 — Write the markdown writeup

After step 5 is approved AND passes the owner/due-date gate, write the file to:

```
retros/retro-<YYYY-MM-DD>-<slug>.md
```

Use this structure:

```markdown
# Retro — <launch-slug> (<marker>)

**Date:** <YYYY-MM-DD>
**Launch:** <launch-slug>
**Marker:** <week-1 | month-1 | other>

## 1. What shipped
<paragraph + links>

## 2. What worked
- …

## 3. What surprised us
- …

## 4. What we'd do differently
- …

## 5. Action items
- [ ] <action> — owner: <role>, due: <date>
- …

## Top lesson (one line)
<single sentence the PM picks as the headline takeaway>
```

Ask the PM for the **top lesson** as the very last input — one sentence, the headline takeaway. This is what gets surfaced in the archive index.

## Phase 3 — Append to the local archive

Target file: `retros/index.html`.

1. If `retros/index.html` does not exist, copy `assets/archive_template.html` to that path. The template already has an empty `<tbody>` inside `<table id="retros">`.
2. Append a new `<tr>` row to the `<tbody>` of `retros/index.html`. Row columns, in order:
   - **Date** — `<YYYY-MM-DD>` (the column the table sorts on)
   - **Launch** — `<launch-slug>`
   - **Marker** — `week-1` / `month-1` / other
   - **Top lesson** — the one-line lesson from Phase 2
   - **Action items** — integer count of action items in step 5
   - **Writeup** — relative link to `retro-<YYYY-MM-DD>-<slug>.md`

Insert the row immediately before the closing `</tbody>` tag. Do not touch anything else in the file (header, CSS, JS, sort logic). HTML-escape the values you insert.

## Phase 4 — Report back

After both files are written, tell the PM:

1. Absolute path to the markdown writeup.
2. Absolute path to `retros/index.html` and how to open it (`open` on Mac, `xdg-open` on Linux, or double-click).
3. The action-item count, and a one-line summary of the top lesson.
4. Offer: run another retro, or stop here.

## Iteration

If the PM wants to revise a retro after it's written:

- For content changes: re-edit the markdown writeup directly. If the top lesson or action-item count changed, also update the matching row in `retros/index.html`.
- For a brand-new retro on the same launch at a different marker (e.g. ran `week-1` last month, now running `month-1`): treat as a new run — new file, new archive row. Do not overwrite the earlier one.

## How this skill differs from adjacent skills

- **comms-pack** — closes the launch loop on the *outbound* side (announcements). retro-facilitator closes it on the *inbound* side (learnings).
- **premortem** — written before launch to surface risk. retro-facilitator validates which premortem stories actually played out.
- **Generic note-taking** — captures whatever you say. retro-facilitator enforces structure and refuses to ship without owners + due dates.
