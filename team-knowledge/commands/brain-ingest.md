---
displayName: 'Brain — Ingest'
description: 'Pull recent activity from sources defined in team-config.yaml and update per-contributor files. The connector logic is user-defined — this command provides the orchestration, dedup, and write-out pattern.'
---

# /brain-ingest

Pull recent artifacts from each teammate's sources and append to their `contributors/<username>.md` file.

## What "ingest" means here

This plugin does **not** ship connectors to specific tools. You bring your own queries against your own systems (chat, code review, docs, tickets). What this command standardizes is:
- the **schedule** (since N days)
- the **per-contributor file format** (Deliverables / Decisions / Blockers / Documents)
- the **dedup contract** (last-sync timestamp per contributor)
- the **provenance trail** (everything also lands in `reports/_source-log/`)

## Phase 0 — Parse args + read config

- Flags: `--since <N>d` (default 7d), `--contributor <username>` (default: all from roster)
- Read `team-config.yaml` → roster + data_sources
- Read `sync-state.json` (if exists) → per-contributor `last_sync` timestamp

## Phase 1 — For each contributor

For each `<username>` in scope:

1. Compute the time window: `max(last_sync, now - --since)` → `now`
2. **You** (the model, or the user) queries each source for that user's activity in the window. The plugin is agnostic to *how* — examples:
   - GitHub: `gh api ...` for merged PRs
   - Linear: `linear-cli issues ...`
   - Slack: a search export, a Zapier dump, an MCP server, etc.
   - Google Docs: Drive API or manual paste
3. Write raw artifacts to `reports/_source-log/<YYYY-MM-DD>/<username>.json` (provenance, never compacted)
4. Classify each artifact into one of four buckets:
   - **Deliverables** — completed PRs/tickets/docs
   - **Decisions** — explicit choices ("we chose X over Y because…")
   - **Blockers** — flagged dependencies, open questions
   - **Documents** — new docs/wikis/slides authored
5. Append (don't overwrite) to `contributors/<username>.md` under the matching section. Use the contributor file template's table format.
6. Update `sync-state.json` with the new `last_sync` for this user.

## Phase 2 — Apply compaction

The contributor template declares per-section compaction inline:

```markdown
## Deliverables
<!-- Compacted after 14 days. -->

## Decisions
<!-- NEVER compacted. -->
```

After appending, walk the file and drop rows whose `Date` is older than the declared window (except sections marked NEVER).

## Phase 3 — Summarize

Print a per-contributor count:

```
ingested:
  alice    — 3 deliverables, 1 decision, 0 blockers, 2 docs
  bob      — 0 deliverables (likely PTO or last_sync recent)
  ...
```

Suggest the next step: `/brain-evolve` to roll contributors into the team brain.

## Important: do not write to CLAUDE.md or intake.md

`/brain-ingest` only touches `contributors/`, `reports/_source-log/`, and `sync-state.json`. It never writes to the team's curated `CLAUDE.md` or to `intake.md` — those are downstream of `/brain-evolve` and `/brain-validate`.
