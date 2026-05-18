---
displayName: 'Portal — Build'
description: 'Render knowledge/*.md into a single self-contained portal/index.html. Zero CDN, stdlib only. Re-run anytime knowledge files change.'
---

# /portal-build

Convert the markdown knowledge base into a single browsable HTML file.

## What gets built

1. Read all `knowledge/*.md` files → render each into a tab in `portal/index.html`.
2. Read `knowledge/deep_dives/*.md` → render under a "Deep dives" submenu.
3. Read `portal/explainers/*.html` → link from the relevant topic page.
4. Inline all CSS and JS into `portal/index.html` (no external dependencies).
5. Drop a build timestamp in the footer.

## Phase 0 — Run the builder

```bash
cd portal/
python3 build_portal.py
```

The builder is stdlib-only — no pip, no node, nothing to install. If python3 is missing, tell the user and stop.

Expected output:
```
build_portal.py — rendered 10 topics, 2 deep dives, 4 explainers → index.html (218KB)
```

## Phase 1 — Validate

Sanity checks after build:
- `portal/index.html` exists and is >50KB (smaller means topics weren't found)
- Open the first 100 lines and confirm the topic nav menu lists all 10 topics
- If any topic markdown has only TODO markers, surface a warning: "domain_knowledge.md is still placeholder — consider filling before sharing"

## Phase 2 — Share

Suggest distribution paths:
- Drop on a static host (S3, GitHub Pages, Vercel)
- Copy into a shared drive folder — the HTML opens locally with no server
- Attach to an onboarding email — works offline once downloaded

The portal is intentionally a single file. No build server, no auth, no JS bundler. If you want auth, host it behind your normal auth proxy.

## Re-run cadence

Whenever a `knowledge/*.md` file changes. For teams that update often, set up a git hook or scheduled job that runs `python3 portal/build_portal.py` on commit. The build is fast (<1s for a typical KB).

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Build errors out on a topic | Markdown syntax issue (broken table, unclosed code fence) | Open the offending .md, fix syntax |
| Topic shows up empty | The .md file has only TODO markers — builder silently includes it | Fill the topic, or temporarily comment the link in `index.html.tmpl` |
| Portal is huge (>10MB) | Embedded images | Move images out, link instead |
| Search doesn't work | The inline JS expected each section to have an `id` attribute — check the template |
