---
name: hallucination-profiler
description: |
  Profiling skill that takes a description of an LLM-powered feature (input shape, output shape, who consumes the output, blast radius) and emits a ranked profile of the top 7 hallucination and failure modes drawn from a canonical 12-mode taxonomy (fabricated entities, fabricated citations, wrong-but-confident, stale-knowledge, format-violation, unit/number errors, prompt-injection-compliance, refusal-when-shouldnt, partial-compliance, conflated-sources, scope-drift, harmful-content). Each chosen mode gets a definition, a feature-specific rationale, a severity × likelihood priority score, a detection strategy (automated, LLM-as-judge, or human review), and a user-facing mitigation (copy + UX pattern). Ends with a day-1 instrumentation list of 3 metrics. Use when the user wants to: pre-build a risk surface for an LLM feature, generate the failure-modes section of an AI feature spec, seed an eval set with weighted failure categories, or pressure-test an AI feature before a launch review.

  Do NOT trigger for: features that don't put an LLM in the response path (use a generic risk register), debugging a specific live failure (use a postmortem), choosing between LLM and rules (use model-vs-rules-matrix), or general "is this AI feature a good idea" framing questions (use idea-killer or hypothesis-canvas).
---

# hallucination-profiler (skill)

Build a feature-shaped risk surface for an LLM-powered feature. The taxonomy is the menu; the feature shape picks the 7 dishes.

## Operating principles

- **Tie every failure mode to the feature's actual input/output shape.** Do not produce a generic "LLMs can hallucinate" list. Every "why it's likely here" must reference at least one specific aspect of the input, output, or consumer flow.
- **Rank by severity × likelihood, not alphabetically.** PMs need a priority order. Compute `priority = severity × likelihood` (max 25) and sort descending. Ties broken by severity.
- **Every mode gets BOTH detection AND user-facing mitigation.** Detection without UX is a dashboard nobody reads. UX without detection is theater. If you cannot specify both, that mode should not be in the top 7.
- **Distinguish hallucination from failure.** Hallucination = the model invents (fabricated entities, fabricated citations, wrong-but-confident, conflated-sources). Failure = the model refuses, drifts, or mis-formats (refusal-when-shouldnt, scope-drift, format-violation, partial-compliance). Both ship as bugs; both belong in the profile.
- **Day-1 instrumentation is mandatory.** End with exactly 3 metrics the team can log from the first build. If a top-7 failure mode has no measurable signal, replace it with one that does or call out the gap explicitly.

## Inputs

- A feature description, passed as `$ARGUMENTS` or pasted into the conversation.

The description MUST include all three of:

1. **Input shape** — what the model sees (text? structured record? doc? thread? user-uploaded file?).
2. **Output shape** — what the model returns (free text? a JSON schema? a single label? a list of recommendations?).
3. **Consumer** — who acts on the output (an end user reading verbatim? an internal employee who edits? another system that parses?).

Blast radius is strongly recommended but not required (per-user, per-team, per-tenant, per-org, public-facing).

If any of input shape / output shape / consumer is missing, respond with a single ask:

> "I need three things before I can profile this: (1) input shape — what the model sees; (2) output shape — what the model returns; (3) who consumes the output. Optional but useful: blast radius (per-user vs. per-org vs. public). Paste a one-paragraph spec and I'll run the profile."

Do not proceed until the user supplies the missing piece.

## Step 1 — Load the taxonomy

Read `assets/failure-taxonomy.md` (relative to this skill). It defines the 12 canonical failure modes. Each entry has: definition, typical detection, typical mitigation. Use those as the starting menu — do not invent new modes outside the 12.

## Step 2 — Score each of the 12 modes for THIS feature

For each of the 12 modes, assign:

- **Severity (1–5)** — how bad is one occurrence given the consumer and blast radius? (e.g., output goes verbatim to a paying customer = high severity; output is edited by an internal expert = lower severity).
- **Likelihood (1–5)** — how often will this mode show up given the input shape and output shape? (e.g., feature outputs citations to external sources → fabricated-citations likelihood is high; feature outputs a single classification label from a closed set → near zero).

Compute `priority = severity × likelihood`. Sort descending.

## Step 3 — Pick the top 7

Take the 7 highest-priority modes. If there are ties at the cutoff, prefer the mode the consumer is least equipped to catch (e.g., an internal expert can catch unit errors; an end user cannot catch a fabricated citation).

For each of the 5 deprioritized modes, keep a one-line note of why for the appendix.

## Step 4 — Profile each of the 7

For each chosen mode, write a block with this exact structure:

```
### N. <mode name> — Priority X/25 (severity Y × likelihood Z)

**Definition.** <1 line from taxonomy>

**Why it's likely here.** <2–3 sentences tying the mode to the actual input shape, output shape, and/or consumer. Reference at least one concrete aspect of the feature.>

**Detection.**
- *Type:* automated check | LLM-as-judge | human review (pick the dominant one)
- *How:* <2–3 sentences, concrete enough to spec — name the check, the threshold, or the rubric>

**Mitigation (user-facing).**
- *UX pattern:* <e.g., inline citation, "AI-generated, review before sending" banner, confirm step, edit-first surface, schema validator with retry>
- *Copy:* "<exact user-facing string, in quotes>"
```

Do not use bracketed placeholders for the copy line — write the actual string a designer would ship. If the feature shape doesn't allow a sensible copy, name the UX pattern that makes the copy unnecessary (e.g., the model output is auto-rejected before reaching the user).

## Step 5 — Day-1 instrumentation

End the body of the artifact with exactly 3 metrics the team should log from the first build. Each metric must:

- Map to one or more of the top-7 failure modes (name which).
- Be logged from product instrumentation, not derived from a separate eval run.
- Be expressible as a numerator/denominator or a counter (no "we'll know it when we see it" metrics).

Example shapes (do not copy verbatim — pick what fits the feature):

- % of outputs where the consumer edited the model's text before acting on it (proxies wrong-but-confident, format-violation, scope-drift).
- Count of outputs containing entity strings not present in the retrieved context (proxies fabricated-entities, conflated-sources).
- % of outputs that failed schema validation on first attempt (proxies format-violation, partial-compliance).

## Step 6 — Write the output

Write everything to `hallucination-profile.md` in the current working directory. Structure:

```
# Hallucination Profile — <short feature slug>

## Feature
- **Input shape:** ...
- **Output shape:** ...
- **Consumer:** ...
- **Blast radius:** ...

## Top 7 failure modes (ranked)

| Rank | Mode | Severity | Likelihood | Priority |
|------|------|----------|------------|----------|
| 1 | ... | 5 | 4 | 20 |
| ... | ... | ... | ... | ... |

## Profiles

### 1. <mode> — Priority X/25
<block from Step 4>

### 2. ...
...

## Day-1 instrumentation

1. <metric> — covers modes [a, b]
2. <metric> — covers modes [c]
3. <metric> — covers modes [d, e]

## Deprioritized (5 of 12)

- <mode>: <one-line why this feature is unlikely to surface it>
- ...
```

After writing, report:

1. Absolute path to `hallucination-profile.md`.
2. The top 3 failure modes by priority.
3. The single mitigation that is most likely to ship in the first sprint (the cheapest UX win).

## How this skill differs from adjacent skills

- **`ai-redteam-prompts`** — turns failure modes into concrete adversarial test prompts. hallucination-profiler picks *which* modes to red-team and weights them; ai-redteam-prompts generates the test strings.
- **`eval-set-curator`** — builds a structured eval set. hallucination-profiler produces the row-category weights the eval set uses; eval-set-curator produces the rows themselves.
- **`model-vs-rules-matrix`** — decides whether the feature should use an LLM at all. hallucination-profiler assumes that decision is made and profiles the resulting LLM feature.
- **`premortem`** — surfaces broad project risks (launch, adoption, dependencies). hallucination-profiler is narrowly scoped to model-output failure modes for a single LLM feature.
- **Generic "list AI risks" prompts** — produce a flat checklist with no priority and no mitigations. This skill ranks by feature-specific severity × likelihood and pairs every mode with detection + UX.
