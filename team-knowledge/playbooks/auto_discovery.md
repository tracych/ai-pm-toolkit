# Auto-discovery playbook

How to design `/brain-ingest` queries against your own sources so the brain stays current without manual entry.

## Core idea

You can't ingest "everything." Auto-discovery picks a small set of signal-rich source queries per contributor, runs them on a cadence, and writes structured rows into `contributors/<username>.md`. The goal is not coverage — it's **signal density**.

## What to query for (per contributor, per source type)

| Source type | What to ingest | Bucket |
|---|---|---|
| Code review (GitHub, Phabricator, etc.) | Merged PRs/diffs authored or reviewed in window | Deliverables |
| Task tracker (Linear, Jira, GitHub Issues) | Closed tasks assigned to user; opened tasks marked "blocker" | Deliverables / Blockers |
| Chat (Slack, Teams, Google Chat) | Messages containing "decided", "we chose", "the call is", "blocker", "blocked on" | Decisions / Blockers |
| Docs (Google Docs, Notion, Confluence) | Docs authored or substantially edited by user in window | Documents |
| Meetings | Decisions section from meeting notes attributed to user | Decisions |
| Status posts (internal blog, group, newsletter) | Posts authored by user | Documents |

## Frequency

Daily ingest is overkill unless your team is in a rapid push. Weekly is the sweet spot:
- More signal per ingest run (easier to dedup)
- One human moderation session per week is sustainable
- Aligns with weekly status rhythms most teams have anyway

## Dedup contract

Each contributor file's last `sync:` HTML comment records the last ingest timestamp. `/brain-ingest` should only pull activity strictly after that timestamp. The raw fetch goes to `reports/_source-log/` so reruns can rebuild without re-querying.

## Don't ingest these

- **Calendar entries** — high noise, low decision content. Pull *meeting notes* instead.
- **Acks/emoji reactions** — no signal.
- **Routine standup updates** — re-derive from the upstream artifact (PR, ticket) the standup is reporting on.
- **Personal HR/career content** — privacy + no team relevance.

## Discovery staging

When first building a brain, stage discovery:

1. **Week 1** — Ingest one contributor only. Confirm the per-contributor file format makes sense.
2. **Week 2** — Add the rest of the roster. Tune the chat keyword filters (false positives are common at first).
3. **Week 3** — Run `/brain-evolve` for the first time. Expect a noisy `intake.md` and a few conflicts. Moderate them; the brain learns from your accept/reject pattern.
4. **Week 4+** — Steady state. Add the `/brain-validate` step if HIGH-confidence claims are slipping in too easily.

## When auto-discovery is wrong

Auto-discovery cannot infer **Goal**, **Strategy**, or **Measurement**. Those are leadership choices. The team brain template marks them `NEEDS HUMAN INPUT` for exactly this reason. Don't try to backfill them from PR descriptions.
