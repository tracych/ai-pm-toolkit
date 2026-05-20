---
name: prd-to-prompt
description: |
  Build-stage skill that turns a PRD section describing desired LLM behavior into a tested system prompt bundle: (1) a versioned system prompt with explicit ROLE / CAPABILITIES / CONSTRAINTS / REFUSAL POLICY / OUTPUT FORMAT / EXAMPLES sections (including a positive AND a negative example), (2) testable assertions extracted 1-to-1 from the PRD's constraints and refusal conditions, (3) a 5-row eval seed where every assertion is exercised by at least one input, and (4) a summary with a version header and change-log seed. Use when the user wants to: convert a PRD section into a system prompt, generate assertions and an eval seed from PRD behavior text, version a prompt from day 1, or get a build-ready prompt + test bundle before wiring up evals.

  Do NOT trigger for: writing the PRD section itself (use /ai-feature-spec first), expanding a 5-row seed into a 50-row eval set (use /eval-set-curator), debugging an existing prompt's hallucinations (use /hallucination-profiler), or any task where the desired behavior is deterministic and shouldn't be an LLM at all.
---

# prd-to-prompt (skill)

Turn a PRD section into a versioned system prompt, testable assertions, and a 5-row eval seed. Constraints become assertions become eval rows — lose one and a bug ships.

## Operating principles

- **Constraints become assertions, 1-to-1.** Every constraint and refusal condition in the PRD must map to a testable assertion. No silent drops.
- **Version from day 1.** The first artifact is `v0.1`, with date and an author placeholder. There is no unversioned prompt.
- **Every assertion has an eval row.** If an assertion can't be exercised by an input, either rewrite it as testable or remove it and flag the gap.
- **Examples are positive AND negative.** At least one example shows what NOT to do, with a one-line note about which constraint it would violate.
- **Refusal policy is explicit.** A refusal condition specifies the trigger AND the exact response text. "Don't hallucinate" is not a policy; `"If transcript is < 100 words, respond exactly: 'I need a longer transcript to summarize.'"` is.

## Inputs

- A PRD section describing desired LLM behavior, passed as `$ARGUMENTS` or pasted into the conversation.

If empty, or if the section contains zero constraints OR zero refusal conditions, respond with a single ask:

> "I need a PRD section with at least one **constraint** (what the assistant must or must not do) and at least one **refusal condition** (when the assistant should decline). Without both, there's nothing reliable to test against. Paste a fuller section, or sketch the two missing pieces and I'll continue."

Do not proceed until the user provides one.

## Step 1 — Parse the PRD section

Read the PRD section and extract four lists. Quote the source phrase for each item.

- **Role / purpose** — what the assistant is for, in one sentence.
- **Capabilities** — what it should be able to do (verbs the user expects).
- **Constraints** — must / must not rules ("never invent attendees", "exactly 3 bullets", "max 200 words").
- **Refusal conditions** — when to decline, and (if specified) the exact response text.

If you can't find at least one constraint AND one refusal condition, stop and use the refusal ask above. Do not fabricate.

## Step 2 — Pick a slug

Derive a short kebab-case slug from the PRD section's subject (e.g., `meeting-summary`, `support-triage`, `prd-reviewer`). 2–4 words max. This is the output directory name.

## Step 3 — Draft the system prompt (`prompt.md`)

Load `assets/prompt-skeleton.md` (relative to this skill) and fill in the six sections. Do not invent sections; do not skip sections.

The prompt begins with a version header:

```
<!--
Version: v0.1
Date: <YYYY-MM-DD>
Author: <unixname or placeholder>
Source PRD: <one-line reference, or "pasted inline">
Change log:
- v0.1 — initial draft from PRD section.
-->
```

Then the six sections, in order:

1. **ROLE** — one paragraph. Who the assistant is, in service of whom.
2. **CAPABILITIES** — bulleted verbs. What it can do.
3. **CONSTRAINTS** — bulleted must / must not rules, lifted directly from the PRD. Each constraint should be phrased so a reader can imagine the failing case.
4. **REFUSAL POLICY** — bulleted. Each item: *trigger* + *exact response text* (or output format for the refusal).
5. **OUTPUT FORMAT** — the literal shape of the output (markdown structure, JSON schema, length budget, etc.).
6. **EXAMPLES** — at least one positive and at least one negative. Negative examples are annotated with the constraint they violate.

## Step 4 — Extract testable assertions (`assertions.md`)

Walk the CONSTRAINTS and REFUSAL POLICY sections of the prompt and emit one assertion per item. Format as a numbered list:

```
1. **[CONSTRAINT]** Output contains exactly 3 bullets at the top level.
   - How to check: count top-level `- ` lines in output; must equal 3.
   - Source PRD phrase: "summarize the meeting in 3 bullets"

2. **[REFUSAL]** If input transcript word count < 100, output is exactly: "I need a longer transcript to summarize."
   - How to check: word-count input; if < 100, string-equality check on output.
   - Source PRD phrase: "refuse if the transcript is < 100 words"
```

If an assertion can't be machine-checked even approximately, mark it `[UNTESTABLE]`, leave it in the list, and flag it in the summary as a PRD gap to resolve in v0.2.

Tag each assertion as `[CONSTRAINT]`, `[REFUSAL]`, or `[FORMAT]`.

## Step 5 — Build the 5-row eval seed (`eval-seed.md`)

Pick 5 inputs that together exercise the riskiest assertions. Rows should include:

- **At least one happy-path row** — typical valid input, expects the full output format.
- **At least one refusal-trigger row** — input designed to fire each refusal condition.
- **At least one boundary row** — input at the edge of a numeric or structural constraint (e.g., exactly 100 words for a "< 100" refusal).
- **At least one adversarial row** — input that tempts the model to violate a hard constraint (e.g., transcript with no attendee names but a question like "who attended?").
- **At least one format-stress row** — input that's valid but unusual in shape (very long, very short within bounds, multi-language, etc.).

Format as a table:

| # | Input (short) | Expected behavior | Pass/fail criteria | Tests assertions |
|---|---------------|-------------------|--------------------|------------------|
| 1 | <one-line input or input file ref> | <what the model should do> | <how a checker decides pass/fail> | #1, #3 |

Every assertion from Step 4 must appear in the "Tests assertions" column of at least one row. If an assertion has no row, add a 6th row or rewrite an existing one — do not ship with uncovered assertions.

## Step 6 — Write the summary (`summary.md`)

A short index file:

```
# <slug> — prompt bundle v0.1

- **Prompt:** ./prompt.md
- **Assertions:** ./assertions.md (N total: C constraints, R refusals, F format)
- **Eval seed:** ./eval-seed.md (5 rows, covering all N assertions)

## Source PRD section
> <verbatim PRD section>

## Open questions / PRD gaps
- <any [UNTESTABLE] assertions and what would make them testable>
- <constraints that were implied but not stated, and the assumption you made>

## Change log
- v0.1 — initial draft from PRD section.
```

## Step 7 — Write the bundle

Create directory `prd-to-prompt/prompts/<slug>/` in the current working directory. Write all four files into it.

After writing, report:

1. Absolute path to the bundle directory.
2. Counts: N assertions (C constraint / R refusal / F format), and confirm all are covered by the 5-row seed.
3. Any flagged `[UNTESTABLE]` assertions or PRD gaps that should be resolved in v0.2.
4. Suggested next step (typically: `/eval-set-curator` to expand the seed, or back to `/ai-feature-spec` if the PRD gaps are blocking).

## How this skill differs from adjacent skills

- **`/ai-feature-spec`** — produces the PRD section in the first place. prd-to-prompt assumes the section already exists and turns it into a build artifact.
- **`/eval-set-curator`** — expands a 5-row seed into a 50-row eval set with adversarial and edge coverage. prd-to-prompt produces the seed; the curator is the next step.
- **`/hallucination-profiler`** — finds failure modes in an *existing* prompt under load. Its output should be folded back into this prompt's REFUSAL POLICY and negative EXAMPLES at v0.2+.
- **Generic "write me a prompt" requests** — produce one prompt with no assertions, no eval, and no version header. This skill refuses to ship a prompt without the test bundle, because the test bundle is what makes the prompt safe to iterate on.
