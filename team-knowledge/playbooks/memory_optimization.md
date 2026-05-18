# Memory & context optimization playbook

How to keep the brain useful as it grows, and how to avoid blowing out an LLM's context window when querying it.

## The three persistence tiers

| Tier | Where | Lifetime | Compaction |
|---|---|---|---|
| **Raw signal** | `reports/_source-log/` | Forever (audit) | Never compacted |
| **Per-contributor structured** | `contributors/<user>.md` | Rolling window | Per-section policy (HTML comments) |
| **Team curated** | `CLAUDE.md` | Indefinite | Manual only via `/brain-moderate` |

Each tier is more selective than the last. Querying always starts at the tightest tier (`CLAUDE.md`) and only widens when the question demands.

## Typed memory schema

Borrowed from the standard Claude Code memory pattern. When `/brain-query` or external agents recall facts about the brain itself (not the team's domain), they should tag memories by type:

| Type | What it stores | Example |
|---|---|---|
| **user** | Preferences of the moderator (terse vs verbose, what they care about) | "moderator prefers HIGH-confidence first, will quit early if intake >20" |
| **feedback** | Corrections + validated approaches | "do not paraphrase decisions — verbatim only. Why: drift over time corrupted decision archeology" |
| **project** | State of the brain itself | "intake backlog is 14 entries deep as of 2026-05-18; needs moderation pass" |
| **reference** | Pointers to external systems | "team's primary chat is in <space-id>; decisions are tagged with [DECISION]" |

These are stored outside the brain, in the LLM agent's own memory file — not in `CLAUDE.md`.

## Declarative compaction

Compaction rules live **inside** the contributor file template as HTML comments:

```markdown
## Deliverables
<!-- Compacted after 14 days. -->

## Decisions
<!-- NEVER compacted. -->
```

`/brain-ingest` reads these comments and applies the rule on each ingest. No side-channel config; no special command. Override per-team in `team-config.yaml` under `compaction_overrides`.

## Lazy loading via per-folder CLAUDE.md

For large brains (>50 contributors, multiple sub-teams), split the brain into sub-folders, each with its own `CLAUDE.md`:

```
brain/
├── CLAUDE.md                  # cross-team summary
├── sub-team-A/
│   ├── CLAUDE.md              # A's brain
│   └── contributors/
├── sub-team-B/
│   ├── CLAUDE.md              # B's brain
│   └── contributors/
```

Claude Code loads only the `CLAUDE.md` of the folder you're working in. This keeps any single query's context bounded.

## Context budget rule of thumb

If the brain fits in ~50KB of markdown, load all of `CLAUDE.md` for any query. Above that, switch to retrieval — `/brain-query` should grep the brain for relevant sections instead of loading wholesale.

## Staleness as a first-class concept

- `team-config.yaml#stale_threshold_days` — contributor files older than this trigger a warning
- `brain-meta.json#last_moderated_at` — if >14 days, `/brain-query` should warn its answers may be stale
- `data.md`-style sidecar (optional) — auto-refreshes upstream data context; if stale, kick off a refresh in background

The brain should always *know* it might be stale, even if it doesn't auto-refresh.
