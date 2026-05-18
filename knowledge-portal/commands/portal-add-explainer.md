---
displayName: 'Portal — Add explainer'
description: 'Generate a stakeholder-friendly HTML explainer for a single subject (a system, model, metric, process). Linked from the relevant topic page.'
---

# /portal-add-explainer

Generate a single-page explainer for one subject. Output is `portal/explainers/<slug>.html`, linked from the relevant topic markdown.

Use this for subjects that:
- Multiple stakeholders ask about repeatedly
- Are too detailed for a topic page but too small for a deep-dive doc
- Benefit from a self-contained "page I can email"

## Phase 0 — Gather inputs

1. Subject name (e.g. "Two-tower retrieval", "p99 latency budget", "Weekly release process")
2. Which topic it belongs under (so we can link from the right page):
   - System or model → `systems_and_models`
   - Metric → `metrics_and_measurement`
   - Process or ritual → `processes_and_rituals`
   - Other → ask the user
3. Audience:
   - `pm-peer` — assumes domain literacy, light on context
   - `xfn` — cross-functional, needs context but not jargon-free
   - `leadership` — high-level, business-impact-first
   - `new-hire` — jargon-free, generous context

## Phase 1 — Draft the explainer

Draft a markdown version first using this structure:

```
# <Subject>

## What it is (1 sentence)
## Why it matters (1 paragraph, audience-tuned)
## How it works (3-5 bullets or a small diagram described in ASCII)
## Where it lives (link to code/docs/dashboards — use placeholders if unknown)
## Who owns it
## Key tradeoffs
## What you should NOT do (gotchas — most-valuable section, often)
## How to learn more (1-3 links)
```

Show the draft to the user, accept edits, then convert to HTML.

## Phase 2 — Render to HTML

Open `templates/explainer.html.tmpl`. It contains five placeholders: `{{SUBJECT}}`, `{{AUDIENCE}}`, `{{TOPIC}}`, `{{LAST_UPDATED}}`, `{{BODY}}`.

There is **no build script** for explainers — perform the substitution by hand (or in this command's response):
- `{{SUBJECT}}` — the subject name
- `{{AUDIENCE}}` — one of `pm-peer` / `xfn` / `leadership` / `new-hire` (uppercase for display)
- `{{TOPIC}}` — the topic slug the explainer belongs under (e.g. `systems_and_models`)
- `{{LAST_UPDATED}}` — today's date (YYYY-MM-DD)
- `{{BODY}}` — the markdown draft from Phase 1, converted to HTML. For simple drafts, hand-convert headers/lists/paragraphs. For complex drafts, paste the markdown through `portal/build_portal.py`'s `md_to_html()` function (it's importable: `from build_portal import md_to_html`).

The template is self-contained — inline CSS, no JS, no CDN. Renders the same on any browser, prints cleanly to PDF.

Write to `portal/explainers/<slug>.html`. Slug is kebab-case version of the subject name.

## Phase 3 — Link from the topic page

Open `knowledge/<topic>.md` and add a line to the "Explainers" section:

```markdown
## Explainers
- [Two-tower retrieval](../portal/explainers/two-tower-retrieval.html)
```

If the topic doesn't have an "Explainers" section yet, add one near the top.

## Phase 4 — Rebuild

Run `/portal-build` so the topic page links go live.

## Anti-pattern

Don't generate explainers for everything. The maintenance cost grows with count. Aim for ~10-20 explainers total per KB. If you have more, you've over-scoped — collapse related ones.
