# Human-on-the-loop playbook

The brain runs autonomously between checkpoints. Humans intervene at exactly three places. Anywhere else, the automation should not need a human.

## The three checkpoints

### 1. Source configuration (one-time, then occasional)

Editing `team-config.yaml` to declare:
- Who's on the team
- What sources to watch for each person
- What the staleness threshold is

This is where you encode trust. If a teammate's PR descriptions are sparse, point ingest at their meeting notes instead. The connector pattern is generic; the *choice* of source is editorial.

### 2. Moderation (every ingest cycle)

`/brain-moderate` walks the intake queue. For each candidate:
- **Accept** — the entry is true and worth surfacing
- **Edit** — true but the phrasing needs work
- **Reject** — false, irrelevant, or premature
- **Skip** — defer to next time

Two design rules make moderation sustainable:
1. **Confidence first** — HIGH entries first, LOW entries last. You can quit any time.
2. **Verbatim decisions** — Decision rows are copied verbatim from contributor files. If you find yourself rewriting a decision, the upstream contributor file is wrong; fix it there.

### 3. Conflict resolution (rare)

When `/brain-evolve` or `/brain-validate` detects a contradiction, it writes to `conflict_log.md` and stops. Humans resolve:
- Pick a claim
- Document a rationale
- Move to "Resolved"

If a topic shows up in conflict_log more than twice, the source filter is wrong — add a manual rule in `team-config.yaml` to disambiguate.

## NEEDS HUMAN INPUT markers

The team brain template literally contains the string `NEEDS HUMAN INPUT` in sections that cannot be inferred from contributor data:
- Goal
- Strategy
- Measurement

`/brain-evolve` will refuse to populate these. `/brain-query` will surface the marker as a caveat when it appears in a relevant answer. This keeps the brain honest about what it doesn't know.

## What human-on-the-loop is NOT

- **Not human approval for every read.** `/brain-query` runs without human checkpoints — it's a retrieval interface, not a write path.
- **Not human-in-the-loop on individual ingests.** Ingest writes to contributor files autonomously. Moderation happens once per cycle, not once per artifact.
- **Not a rubber stamp.** If you find yourself accepting >95% of intake without editing, your ingest is under-filtering — tune the queries instead of clicking through.

## Failure modes

| Symptom | Likely cause | Fix |
|---|---|---|
| Intake too long to walk | Ingest is over-pulling | Tighten chat keyword filters; reduce window |
| Same conflict every week | Two sources have conflicting metadata | Pick one source as authoritative in `team-config.yaml` |
| Brain feels stale | Moderation skipped, intake backlog | Schedule moderation on a weekly calendar slot; don't queue >2 cycles |
| Human bypass (people editing CLAUDE.md directly) | Moderation overhead too high | Reduce ingest frequency; trust quality over freshness |
