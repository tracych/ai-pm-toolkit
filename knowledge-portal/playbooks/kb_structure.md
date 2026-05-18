# KB structure playbook

Why the 10 topics. What goes in each. How to resist growth.

## The 10 topics, with what belongs and what doesn't

### `domain_knowledge`
**Belongs:** what this domain *is*, vocabulary, the user/problem we serve, business model fundamentals.
**Doesn't:** specific system designs (→ `systems_and_models`), specific metrics (→ `metrics_and_measurement`).

### `systems_and_models`
**Belongs:** what's running in production, how the pieces connect, key tradeoffs in current architecture.
**Doesn't:** historical systems we've deprecated (delete or archive), future systems we plan to build (→ team-knowledge brain or a roadmap doc, not here).

### `metrics_and_measurement`
**Belongs:** primary metrics, guardrails, how we A/B, what counts as a regression.
**Doesn't:** dashboard URLs (→ `resources`), specific experiment results (→ deep dives).

### `people_and_org`
**Belongs:** who owns what *area* (not necessarily who's currently assigned), key partner teams, decision authority.
**Doesn't:** current sprint assignments (→ team-knowledge brain), org chart positions that change quarterly.

### `processes_and_rituals`
**Belongs:** how decisions get made, release cadence, on-call rotation, retro format.
**Doesn't:** ad-hoc workflows for a single project, anything that's true for <6 months.

### `gotchas_and_tips`
**Belongs:** "I wish someone had told me." Non-obvious things that bite people. Workarounds for known issues.
**Doesn't:** bug tickets (→ tracker), fully-resolved issues (delete the gotcha when the fix lands).

### `resources`
**Belongs:** canonical links — top 3 dashboards, top 5 docs, the wiki landing page, the runbook.
**Doesn't:** every link ever shared in chat (the resources file is the *curated* list, not the union).

### `skills`
**Belongs:** AI/automation skills the team uses repeatedly. Slash commands, agents, MCP servers, shared prompts.
**Doesn't:** one-off prompts a single person uses.

### `industry_landscape`
**Belongs:** competitor moves, research papers worth knowing, regulatory or market shifts.
**Doesn't:** all news (curate ruthlessly), exhaustive competitor analysis (→ a deep dive).

### `intake`
**Belongs:** proposed additions awaiting review. Things you don't yet trust enough for a topic page.
**Doesn't:** stale items (sweep monthly; if not promoted in 30 days, drop or delete).

## Resisting growth

The pressure to add an 11th topic comes from the same place every time — a new project gets big enough that team members want a dedicated page. **This is what `deep_dives/` is for.** Spinning up new top-level topics shatters the consistency that makes the structure useful.

Heuristic: if a new topic would be empty in 6 months, it's a deep dive, not a topic.

## Editorial voice

Each topic has one maintainer. The maintainer's job is to keep the topic *coherent*, not to write all the content themselves. They edit drive-by additions into the voice. Inconsistent voice is what makes wikis unreadable.

## When a topic doesn't apply

Empty topics are fine. `industry_landscape` may be N/A for an internal-only team — leave it as a stub explaining why it's empty. Better to acknowledge the gap than to fill it with filler.
