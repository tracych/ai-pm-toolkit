---
displayName: 'PM Dive — Run'
description: 'Spawn parallel research agents per angle from frame.json, then run adversarial validation pass. Implements a parallel multi-agent research pattern with PM dive folder conventions.'
---

# /pm-dive-run

**Stage 3–4 of pm-deep-dive.** Reads `frame.json`, spawns one research agent per angle in parallel, then runs an adversarial validator that defaults to refuting medium-confidence claims.

## Conventions

This command implements a parallel-agent spawning pattern with PM-specific conventions:
- Output files numbered + named by angle (`01_<angle_slug>.md` … through `06_<angle_slug>.md`)
- Adversarial validators use named files (no number — they are a separate artifact category, not an angle): `validation_code.md` / `validation_knowledge.md`
- Confidence rubric from `assets/confidence_rubric.md` enforced in agent prompts

If a generic parallel-agent research skill is also installed and the user prefers it for the parallel stage, they can run that directly and then call `/pm-dive-summarize` on the dive folder — both work.

## Phase 0 — Read frame

1. Locate `frame.json` (current dir, or path argument).
2. Validate schema (claim, audience, depth, angles, dive_folder all present).
3. Echo frame summary to user, ask for confirmation: *"Spawning {N} agents at {depth} tier. Estimated runtime: {quick=10min / standard=30min / deep=60min}. Continue?"*

## Phase 1 — Spawn parallel research agents

Spawn **one Agent per angle, in a single message with multiple Agent tool uses** for true parallelism.

For each angle in `frame.angles`, use the `general-purpose` subagent (it has `Write` access — read-only research subagents do not).

Per-agent prompt template (orchestrator must substitute the bracketed `{...}` placeholders, including `{frame.domain_maturity}`, before spawning):

```
You are researching ONE angle of a PM deep dive. You will not see the other agents' work — independence is what makes cross-validation meaningful.

DIVE CLAIM: {frame.claim}
YOUR ANGLE: {angle.name}
YOUR JOB: {angle.instruction}
DEPTH: {frame.depth}
AUDIENCE: {frame.audience}
DOMAIN MATURITY: {frame.domain_maturity}   # "established" or "new_bet" — affects how you tag confidence

OUTPUT REQUIREMENTS:
Write your findings to: {frame.dive_folder}/{angle.id}_{angle.name}.md

File structure:
1. TL;DR — 3 sentences max
2. Key findings — each tagged with confidence: HIGH / MEDIUM / LOW + source citation
3. Sources used — with links/IDs where possible
4. Open questions — what you couldn't resolve

CONFIDENCE RUBRIC (your single-angle view — final cross-validation happens later):
- HIGH: ≥3 independent sources agree (this angle alone), OR primary source with direct substantiation
- MEDIUM: 1–2 sources, or single primary source without independent confirmation
- LOW: inference, single secondary source, or uncertain extrapolation

IMPORTANT — pure source counting, no validator-aware downgrade at this stage:
- DO NOT mark a finding LOW just because you couldn't find code substantiation. The validator pass (or the cross-angle synthesizer) will handle that downgrade later.
- In `new_bet` mode (when DOMAIN MATURITY = new_bet), code substantiation is *not expected* — absence of code is the default state of a 0→1 area. Tag confidence based purely on independent sources you DO find (UXR, posts, peer interviews, market data, surveys, public benchmarks). Do not penalize for code absence.
- In `established` mode, code/data substantiation strengthens HIGH but is not required at the single-angle level — the validator pass will check this in Phase 2.

RULES:
- Cite primary sources, not summaries-of-summaries
- If you find evidence that REFUTES the dive claim, flag it loudly in TL;DR
- Do not editorialize beyond your angle — synthesis happens later
- Use `Grep` / `Glob` / `Read` for the local codebase
- Use `WebFetch` / `WebSearch` for external sources (papers, competitor docs, blog posts)
- If your team uses internal docs/wikis, swap in the relevant tool for those sources

Save your file. Return a 2-sentence summary of your top finding to the orchestrator.
```

**Save outputs as numbered files**: `{dive_folder}/{angle.id}_{angle.name}.md`

If an agent returns content inline without writing (sub-agent tool grant gap), the orchestrator writes the file from the inline content. Do not lose work.

## Phase 2 — Adversarial validation pass

**Behavior depends on `frame.depth` AND `frame.domain_maturity`:**

| depth | domain_maturity | Code validator | Knowledge re-validator |
|-------|-----------------|----------------|------------------------|
| `quick` | any | skip | skip |
| `standard` | `established` (default) | run | skip |
| `standard` | `new_bet` | **skip** (no code expected) | run instead — re-validate via narrow web/doc search |
| `deep` | `established` | run | run |
| `deep` | `new_bet` | **skip** | run (with extra emphasis on stakeholder/UXR triangulation) |

Rationale: `new_bet` claims describe a 0→1 area where code may not exist yet. Running a code validator there guarantees UNFOUND for every claim, which is signal-free. Skip it; lean on knowledge re-validation and angle agreement instead. The summarizer enforces the matching confidence bar via `assets/confidence_rubric.md`.

### Code validation agent (when applicable per table above)

Read `assets/adversarial_prompts.md` for the refute-by-default validator prompt template. Spawn a `general-purpose` agent with:

```
You are an ADVERSARIAL code validator. Default to refuting claims unless code substantiates them.

DIVE CLAIM: {frame.claim}
CLAIMS TO VALIDATE: {bulleted list of MEDIUM and LOW confidence claims extracted from Phase 1 outputs}

Read each angle file in {dive_folder}/0[1-6]_*.md. Extract MEDIUM/LOW claims.

For each claim, search for confirming or refuting code evidence:
- `Grep` / `Glob` for symbols, files, function names
- `Read` for specific files
- `WebFetch` for linked PRs, design docs, post-mortems

Return one of: CONFIRMED / REFUTED / INFRA-CONFIRMED-NUMBER-UNRESOLVED / UNFOUND
With file:line citations or PR URLs.

Write to: {dive_folder}/validation_code.md
```

### Knowledge re-validation agent (when applicable per table above)

```
You are an ADVERSARIAL knowledge re-validator. Re-search single-sourced or stale claims with NARROW queries.

CLAIMS TO RE-VALIDATE: {claims with single source or older than 6 months}

Re-issue NARROW `WebSearch` / `WebFetch` queries against current docs/posts/post-mortems. Either confirm with a fresh source or surface the claim as stale.

Write to: {dive_folder}/validation_knowledge.md
```

## Phase 3 — Validator failure handling

If validator returns transport errors / zero results:
1. Try minimal direct validation in the orchestrator (`Grep` / `WebSearch` on top 5 critical claims, best-effort).
2. If still failing, write `validation_code.md` as an **incomplete-validation record** documenting which claims are unverified and why.
3. The summarizer (`/pm-dive-summarize`) will surface this gap loudly.

For `new_bet` mode where code validator was skipped by design (not failed): no gap — write `validation_code.md` with a one-line "Skipped: domain_maturity=new_bet, code validation not applicable to a 0→1 area" so the summarizer doesn't mistake skip for failure.

## Phase 4 — Hand off

Print to user:

> Run complete. Files in `{dive_folder}`:
> - frame.json
> - 01_*.md … 0N_*.md (raw research, N up to 6)
{conditional lines based on what actually ran — see table below}

| Condition | List this line |
|-----------|----------------|
| `depth=quick` | (no validator lines) |
| `depth>=standard` AND `domain_maturity=established` | `validation_code.md` |
| `depth=deep` AND `domain_maturity=established` | also: `validation_knowledge.md` |
| `depth>=standard` AND `domain_maturity=new_bet` | `validation_code.md` (skipped: domain_maturity=new_bet)<br>`validation_knowledge.md` |

The orchestrator MUST only list files that actually exist on disk.
>
> Next: `/pm-dive-summarize` to produce the cross-validation matrix and verdict.

---

## Anti-patterns

- ❌ Spawn agents serially (kills parallelism — must be one message, multiple Agent calls)
- ❌ Use specialized read-only subagents (no Write access — use `general-purpose`)
- ❌ Let agents see each other's output before writing
- ❌ Polite validators — they must default to refuting
- ❌ Drop validator failures silently — surface in summary

## Standalone use

A PM with their own raw agent outputs in a dive folder can call `/pm-dive-run` with `--validate-only` to skip Phase 1 and just run the adversarial validator. (TODO.)
