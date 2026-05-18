---
displayName: 'Portal — Add topic'
description: 'Add a new topic .md to the knowledge base. Use sparingly — the 10-topic structure is opinionated and resists growth.'
---

# /portal-add-topic

Add a new top-level topic to the knowledge base.

## When to use this

**Almost never.** The 10-topic structure is intentionally tight. Before adding a topic, ask:
- Does this belong in an existing topic? (Most additions belong in `systems_and_models.md` or `gotchas_and_tips.md`)
- Is this a **deep dive** rather than a topic? (Use `/portal-add-explainer` or hand-add to `knowledge/deep_dives/`)
- Is it temporary? (Use `intake.md` for in-flight work)

If you still need a new topic, proceed.

## Phase 0 — Argue against it

Ask the user to write one sentence answering "why is this distinct from <closest existing topic>?" If the answer is unclear, push back. The 10-topic structure is the product.

## Phase 1 — Create the topic file

1. Ask for: topic name (free text), filename (snake_case `.md`)
2. Copy `templates/knowledge_topic.md.tmpl` → `knowledge/<filename>.md`
3. Replace `<TOPIC>` placeholders with the topic name

## Phase 2 — Wire it into the portal

The portal builder reads all `knowledge/*.md` files automatically. New topics will appear on next `/portal-build`. But:

1. Open `portal/index.html.tmpl` and add the new topic to the nav menu ordering (the builder uses this for nav order; without it, the topic appears in alphabetical order which may be jarring).
2. Update `README.md` to mention the new topic.
3. Rebuild: `/portal-build`

## Phase 3 — Audit afterward

A week after adding, look at the new topic. If it has fewer than 3 substantive sections, fold it into an existing topic and delete it. New topics that don't grow are clutter.
