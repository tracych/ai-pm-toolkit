# Conflict detection prompt

Loaded by `/brain-evolve` (during the diff-against-CLAUDE.md step) and `/brain-validate` (after adversarial pass). The detector's job is to spot two-claim contradictions, not to resolve them.

## What counts as a conflict

A conflict requires **two claims that cannot both be true**. Examples:

| Claim A | Claim B | Conflict? |
|---|---|---|
| "Project X is on track" | "Project X is at risk (red)" | YES |
| "Alice owns the migration" | "Bob owns the migration" | YES |
| "We decided to use Postgres" | "We decided to use MySQL" | YES (for the same decision moment) |
| "We decided to use Postgres for service A" | "We decided to use MySQL for service B" | NO (different scopes) |
| "Launch date is March" | "Launch is delayed" | YES (resolve by date) |
| "Team is 12 people" | "Team is 14 people" | MAYBE — could be a counting basis difference; flag for human |

## Detector prompt

```
You are a conflict detector. Given two candidate entries (or one candidate and one existing CLAUDE.md line), decide whether they contradict.

CLAIM A: {text + source}
CLAIM B: {text + source}

Return ONE of:
- **CONFLICT** — both cannot be true. Explain the contradiction in one sentence.
- **PARTIAL** — they overlap but could both be true under different scopes. Specify the scope ambiguity.
- **CONSISTENT** — no contradiction.

Be conservative on PARTIAL. If scope is unclear, flag PARTIAL rather than CONSISTENT — humans can disambiguate cheaply.
```

## Where each verdict goes

| Verdict | Action |
|---|---|
| CONFLICT | Write to `conflict_log.md#open-conflicts`. Block both claims from reaching CLAUDE.md until resolved. |
| PARTIAL | Write to `conflict_log.md#open-conflicts` with the scope ambiguity noted. Surface to moderator. |
| CONSISTENT | Proceed normally. |

## Anti-patterns

- **Detecting conflict between a claim and a stale CLAUDE.md entry**: if the existing entry is >30 days old and the new claim updates it, that's an *update*, not a conflict. Route to `intake.md#proposed-updates`.
- **Detecting conflict between two paraphrases of the same source**: if both claims trace to the same primary source, the conflict is in the paraphrasing — fix the contributor file rather than logging a conflict.
- **Over-detecting**: false positives drain moderator energy. The detector should err on CONSISTENT when truly ambiguous, not on PARTIAL.
