# Confidence rubric

Read by `/brain-evolve` (initial labeling) and `/brain-validate` (re-labeling after adversarial pass).

## The three levels

### HIGH

A claim is HIGH-confidence if **either**:
- ≥2 truly independent contributors reported it (independent = different primary source, not the same doc quoted twice), **or**
- 1 contributor reported it AND the adversarial validator returned CONFIRMED with a primary-source citation

HIGH means: surface to leadership without caveat. Eligible for the team brain's curated sections.

### MEDIUM

A claim is MEDIUM-confidence if:
- 1 contributor reported it AND a corroborating but indirect artifact exists (status post, summary doc, secondary mention), **or**
- 2 contributors reported it but both trace to the same primary source, **or**
- Adversarial validator returned UNFOUND but the claim is plausible given context

MEDIUM means: directionally true, verify before quoting externally. Acceptable in the brain with a `~` prefix indicating tentativeness.

### LOW

A claim is LOW-confidence if:
- 1 contributor only, no corroboration, **or**
- Adversarial validator returned UNFOUND AND the claim is unusual/surprising, **or**
- Contradicted by another contributor but not yet escalated to `conflict_log.md`

LOW means: hypothesis only. Worth investigating, not worth stating. Should not reach `CLAUDE.md` until promoted.

## What is "truly independent"

Two contributors are independent sources iff their primary artifacts are different. Heuristics:

| Contributor A source | Contributor B source | Independent? |
|---|---|---|
| PR #123 | PR #123 review comment | NO — same artifact |
| Doc X | Chat message linking Doc X | NO — derivative |
| Doc X | Doc Y (different authors, different topics) | YES |
| Meeting notes | Their own PR that came out of the meeting | NO — same decision moment |
| Their own PR | Someone else's PR doing related work | YES |

When unsure, treat as NOT independent. The rubric should err toward MEDIUM rather than HIGH.

## Confidence as a write-only target

Once a claim reaches `CLAUDE.md` via `/brain-moderate`, the confidence label is dropped. The brain itself is the curated truth — entries in it are assumed correct. Confidence labels live in `intake.md`, not `CLAUDE.md`.

If a published entry is later contradicted, it goes to `conflict_log.md` for re-review — not back to intake.
