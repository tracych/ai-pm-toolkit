---
name: comms-pack
description: |
  From a single launch brief paragraph, generate six audience-tuned comms artifacts (release notes, internal announcement, exec update, customer email, social post, FAQ) plus a single-file HTML preview that tabs across all six. Use when the user wants to: draft a full launch comms set in one pass, get audience-specific framings of the same launch (exec vs customer vs social), produce a shareable preview of the whole comms pack before sending anything, or pressure-test claims in exec/customer comms for unsupported assertions. Triggers on language like "draft launch comms", "I need an announcement + email + social for X", "comms pack for this launch", "spin up release notes and FAQ", "we're shipping X next week, help me write the comms".

  Do NOT trigger for: incident or rollback comms (use rollback-planner — different rules, different shape), single-artifact requests where the user already knows exactly the one thing they need, comms requiring legal/PR as the primary author, or brand-voice-critical surfaces like homepage copy or brand campaigns.
---

# comms-pack (skill)

Take a single launch brief and fan it out to six audience-tuned comms artifacts, then bundle them in a tabbed HTML preview. One brief in, full launch pack out — with visible flags on any claim the brief doesn't support.

## Operating principles

- **One brief, six voices.** Same facts, six different framings. If the exec update reads like the customer email, the pack has failed — rewrite for audience.
- **Flag undefended claims.** On `exec-update.md` and `customer-email.md`, every numeric, comparative, or causal claim must trace to the brief. If it doesn't, insert `[NEEDS EVIDENCE: <what's missing>]` inline rather than inventing support.
- **Preview before send.** Always emit `index.html` — a human should eyeball the whole pack in one shot before any artifact ships.
- **Refuse thin input.** Brief under 20 words → refuse and ask for more. Comms blast radius is too big to guess at.
- **Plain markdown + vanilla HTML.** No frameworks, no CDN, no dependencies. Outputs are copy-pasteable into any downstream tool.
- **Honest draft posture.** The preview shows a visible "draft — review before sending" pill. Never let a preview be mistaken for approval.

## Phase 0 — Parse input

Input format: `$ARGUMENTS` is either:

- `<launch brief paragraph>` — generate all 6 artifacts, or
- `[audience1,audience2,...] <launch brief paragraph>` — generate only the listed subset.

Valid audience names (this exact order matters for the preview):

```
release-notes, internal, exec-update, customer-email, social, faq
```

Steps:

1. **Word-count the brief.** If under 20 words, refuse: "Brief too thin — need at least 20 words covering what's shipping, who it's for, and why it matters. Try again with more substance."
2. **Derive a `<slug>`** — kebab-case, 2-4 words, from the most distinctive nouns/verbs in the brief (e.g. "shared-doc-autosave", "creator-tipping-launch"). This names the output folder.
3. **Resolve audience list** — if no filter, all six. If filter, validate each name is in the list above; warn and skip unknowns.

## Phase 1 — Generate artifacts

For each audience in the resolved list, generate the artifact per the spec in `assets/audience_templates.md`. Tone and length differ visibly per audience — exec should not read like customer should not read like social.

Per-audience high-level rules (full templates in the assets file):

- **release-notes** — markdown, 3 sections (What / Why it matters / Get started), 100-200 words, neutral product voice.
- **internal** — markdown, 5 bullets (what shipped / who built it / who to thank / what's next / where to give feedback), under 150 words, warm internal tone.
- **exec-update** — markdown, 5 bullets + 1 ask line, under 120 words, **business-impact framing only** (no implementation detail, no team shout-outs).
- **customer-email** — markdown, friendly tone, structure: `Subject: <line>` then 3 short paragraphs + 1 CTA. Write second-person ("you").
- **social** — single block, ≤280 chars total. Hook + value + CTA in that order. No hashtag spam — at most 2.
- **faq** — markdown, 8 Q&A pairs total: first 4 are common questions ("when does it ship?", "who gets it?", "how do I turn it on?", "what does it cost?"), last 4 are sharp-edge questions a skeptic would ask ("what's the catch?", "what breaks?", "what about <competitor>?", "what if I don't want it?").

Write each artifact to `comms-pack/<slug>/<audience>.md` (or `.md` for social too — single block, but markdown file).

## Phase 2 — "Can't defend this" pass

After generating `exec-update.md` and `customer-email.md`, re-read each one. For every:

- Numeric claim ("cuts incidents by 40%")
- Comparative claim ("faster than X")
- Causal claim ("because of this, users will Y")
- Adoption claim ("most teams already...")

…check whether the brief contains support. If not, replace the claim with `[NEEDS EVIDENCE: <what would need to be true>]` inline. Example:

```
Before: Saves users 3 hours per week on document recovery.
After:  Saves users [NEEDS EVIDENCE: time-saved metric not in brief] on document recovery.
```

Do not do this pass on release-notes (already factual-by-template), internal (audience tolerates rougher claims), social (constraint is length, not rigor), or FAQ (questions, not assertions).

## Phase 3 — Emit preview

1. Read `assets/preview_template.html`.
2. For each audience that was generated, replace the corresponding `<!-- SLOT:<audience> -->` marker with the artifact's content wrapped for safe HTML display:
   - HTML-escape `&`, `<`, `>` in the markdown content.
   - The template already wraps each slot in a `<pre>` for monospace render — escaped content goes inside.
3. For audiences that were filtered out, replace the slot with a short "Not generated in this pack." note inside the `<pre>`.
4. Write the result to `comms-pack/<slug>/index.html`.

Keep the preview self-contained: vanilla JS tab switcher already in the template, zero CDN, opens offline by double-click.

## Phase 4 — Report

After writing all files, report to the PM:

1. The `<slug>` and absolute path to `comms-pack/<slug>/`.
2. List of artifacts written (mark any that were filtered out).
3. Count of `[NEEDS EVIDENCE: ...]` flags raised, per file.
4. How to open the preview (`open <path>` on Mac, `xdg-open <path>` on Linux, or double-click).
5. Offer: regenerate a specific audience, tighten any artifact, or ship as-is.

## Iteration

When the PM comes back with "tighten the exec update" / "rewrite social for a different hook" / "add a 9th FAQ":

- Regenerate only the requested audience(s).
- Re-run the "can't defend this" pass if exec-update or customer-email changed.
- Re-emit `index.html` so the preview stays in sync.
- Overwrite in place. PM can `cp -r <slug> <slug>-v2` if they want variants.

## How this skill differs from adjacent skills

- **rollback-planner** — ships 3 *incident* comms (status update, customer apology, postmortem). comms-pack ships the 6 *routine launch* comms. Different audiences, different tone, different rules. Use both if you need both.
- **protopilot** — produces a clickable prototype, no comms. Use protopilot's PM notes as the seed brief for comms-pack.
- **retro-facilitator** — runs after the launch lands. comms-pack runs before/at launch.
