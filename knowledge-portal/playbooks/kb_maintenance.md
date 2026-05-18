# KB maintenance playbook

How to keep the KB true. What to refresh on what cadence. When to declare bankruptcy.

## The freshness signal

Each topic file ends with:

```
---
*Maintainer: <username>*
*Last reviewed: <YYYY-MM-DD>*
```

Quarterly: open each topic, scan for staleness, update `Last reviewed`. If you didn't actually re-read it, don't update the date — false freshness is worse than honest staleness.

The portal builder will highlight files >180 days unreviewed in a future revision; for now, an honest date is the discipline.

## The "Things that have changed recently" section

Every topic has it. This section is the **lightweight changelog** for the topic. New maintainer? Read this section first. It tells you what shifted recently and what context the rest of the topic might be missing.

If you make a substantive edit to a topic, add a row.

## Quarterly review checklist

For each topic, ask:
- Are any sections describing systems that no longer exist? → delete
- Are there links that 404? → fix or remove
- Are there names of people who left the team? → replace with role, not name
- Is the "Open questions" section the same as last quarter? → either answer them or remove them
- Is the maintainer still here? → re-assign

## When to declare bankruptcy

If on the quarterly pass you find the topic has >50% stale content, don't try to fix in place. Rewrite from scratch in a new file (`<topic>_v2.md`), then swap. Stale content with token edits on top is worse than a fresh start.

## When to retire deep dives

A deep dive should reach one of three end-states:

| End state | Action |
|---|---|
| Findings still actively referenced | Status: `active`. Keep as-is. |
| Findings folded into a topic | Status: `archived`. Add one-line pointer to the topic. Keep file for audit. |
| Findings no longer relevant | Status: `archived`. Add one-line note. Keep file (don't delete history). |

Archived dives stay in `deep_dives/` and stay in the portal nav, but in a collapsed group. Knowledge of *what we used to think* is sometimes more valuable than what we think now.

## When to retire explainers

Same rule. If an explainer hasn't been opened in 90 days (you can tell via host analytics or just by asking the team), delete it. Explainers exist to be sent — if nobody's sending it, it's dead weight.

## Intake hygiene

`intake.md` should never have >20 open items. If it does, either:
- Run a moderation pass and clear it, or
- The team isn't using the intake → delete entries older than 60 days

A long intake demotivates moderation. Keep it short by being willing to delete.

## Conflict log hygiene

`conflict_log.md` is the only file with no compaction. Every entry, every resolution, lives forever. This is by design — conflict archaeology is how you avoid relitigating decisions.

If the log gets long enough to feel unwieldy, split by year (`conflict_log_2025.md`, `conflict_log_2026.md`). Don't compact.
