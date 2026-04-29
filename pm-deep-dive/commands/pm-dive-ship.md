---
displayName: 'PM Dive — Ship'
description: 'Productize a SUMMARY into a blog post or executive brief. Each format is independent — pick what you need. HTML explainer format is v0.3.'
---

# /pm-dive-ship

**Stage 6 of pm-deep-dive.** Turns `00_SUMMARY.md` into a shareable artifact. Fan-out, not pipeline — pick the format you need.

## Usage

```
/pm-dive-ship --format post     # Blog / team-announcement post (markdown)
/pm-dive-ship --format exec     # 1-page executive brief
/pm-dive-ship --format html     # Interactive explainer (DEFERRED to v0.3)
```

If `--format` not given, ask the user which.

## Phase 0 — Load

1. Locate dive folder.
2. Read `00_SUMMARY.md`. Fail loudly if missing — direct user to `/pm-dive-summarize` first.
3. Read `frame.json` for `audience` and `domain_maturity` (default `established` if absent).

## Phase 1 — Generate

### `--format post`

Read `assets/templates/blog_post.md`. Fill from SUMMARY:
- Title from claim
- Hook paragraph from TL;DR
- 3–5 high-confidence findings as scannable bullets
- "What I'd do next" from suggested follow-ups
- Honest caveats from validation gap section. **If `domain_maturity=new_bet`, prepend a one-liner to caveats: *"This dive investigates a 0→1 area — code/data validation was not applicable. Findings are validated via cross-angle agreement and knowledge re-search, not against the codebase."***

Output: `{dive_folder}/blog_post.md`

### `--format exec`

Read `assets/templates/exec_brief.md`. Fill from SUMMARY and `frame.json`:
- `{username}` — populate from `frame.created_by` (or run `whoami` as fallback)
- `{audience}` — populate from `frame.audience`
- One-line verdict (CONFIRMED / REFUTED / PARTIAL)
- **Validation bar disclosure** — one line stating `domain_maturity` and what was validated. Examples:
  - `established`: *"Validated via cross-angle agreement + adversarial code search of the codebase."*
  - `new_bet`: *"Validated via cross-angle agreement + adversarial knowledge re-search. Code-grounded validation not applicable (0→1 area)."*
- Why it matters (business framing — explicitly tie to a metric)
- 3 highest-confidence findings
- Risks / what we don't know (validation gap)
- Recommended next step

Output: `{dive_folder}/EXEC_SUMMARY.md`

Constraint: must fit on one page when printed. Force concision.

### `--format html` (v0.3 — not implemented)

Print: *"Interactive HTML explainer is planned for v0.3. For now, use `--format post` for a shareable artifact."*

## Phase 2 — Hand off

Print to user:

> Shipped: `{output_file}`
>
> Review before posting. The skill writes drafts, not final copy. Check:
> - Tone matches your audience ({frame.audience})
> - Caveats are honest (don't overstate confidence)
> - Business framing ties to a metric

> Next: `/pm-dive-land` to feed findings into project knowledge so the next session inherits them.

**Do not auto-post.** Always human-in-the-loop for anything going to a public channel / leadership.

---

## Anti-patterns

- ❌ Auto-post to any chat / blog channel
- ❌ Generate a deck / .pptx (out of scope — use a separate skill)
- ❌ Inflate confidence beyond what SUMMARY supports
- ❌ Drop the validation gap caveats from the artifact

## Standalone use

A PM with a hand-written `00_SUMMARY.md` can call `/pm-dive-ship` to generate the post / exec brief without running the rest of the pipeline.
