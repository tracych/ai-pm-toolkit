# prd-to-prompt

Turn a PRD section describing an LLM behavior into a tested system prompt with assertions, an eval-seed, and a versioning header.

## What it does

Takes a PRD section that describes desired LLM behavior — e.g., *"the assistant should summarize the meeting in 3 bullets, never invent attendees, and refuse if the transcript is < 100 words"* — and produces a build-ready bundle:

1. **A versioned system prompt** (`prompt.md`) with explicit sections: ROLE, CAPABILITIES, CONSTRAINTS, REFUSAL POLICY, OUTPUT FORMAT, EXAMPLES (positive AND negative). Starts with a version header (v0.1, date, author placeholder) so changes are traceable from day 1.
2. **A list of testable assertions** (`assertions.md`) extracted 1-to-1 from the constraints and refusal conditions in the PRD ("output is exactly 3 bullets", "no attendee names not present in input", "refuses if input < 100 words"). If a PRD constraint can't be turned into something a machine could check, the skill flags it as untestable and asks you to tighten the PRD.
3. **A 5-row eval seed** (`eval-seed.md`) with inputs designed to hit the riskiest assertions, expected behavior per row, and pass/fail criteria. Every assertion has at least one row that would catch its violation.
4. **A summary** (`summary.md`) with links, version, and a change-log seed for the next iteration.

If the PRD section doesn't include at least one constraint AND one refusal condition, the skill refuses — those are the cheap-to-violate bugs that ship without a test.

## Use it

In Claude Code (with this repo in your workspace):

```
/prd-to-prompt The assistant summarizes meeting transcripts in exactly 3 bullets. Never invent attendees. Refuse if transcript < 100 words.
```

Or paste a longer PRD section into the conversation and let the skill auto-trigger on phrasing like "turn this into a system prompt", "I have a PRD section for an LLM feature", "give me a prompt + eval for this behavior".

If your PRD section has no constraints or no refusal conditions, the skill will refuse and ask you to add them — a prompt with no constraints has nothing to assert against.

## Output

A directory `prd-to-prompt/prompts/<slug>/` in your current working directory, containing:

- `prompt.md` — the versioned system prompt (ROLE / CAPABILITIES / CONSTRAINTS / REFUSAL POLICY / OUTPUT FORMAT / EXAMPLES)
- `assertions.md` — testable assertions, 1-to-1 with PRD constraints + refusal conditions
- `eval-seed.md` — 5 rows: input × expected behavior × pass/fail criteria, each tagged with the assertion it tests
- `summary.md` — version, date, links to the other three files, and a change-log seed

## When NOT to use

- You haven't written the PRD section yet — use `/ai-feature-spec` first.
- You need a 50-row eval, not a 5-row seed — pass this seed to `/eval-set-curator`.
- You're debugging hallucinations on an *existing* prompt — use `/hallucination-profiler`, then loop its output back into the refusal policy here.
- The behavior is deterministic and doesn't need an LLM — write a function and a unit test.

## Operating principles

- **Constraints become assertions, 1-to-1.** Every constraint in the PRD must map to a testable assertion. Lose one and a bug ships.
- **Version from day 1.** The system prompt has a version header (v0.1, date, author placeholder) so changes are traceable. There is no "v0" — the first artifact is `v0.1`.
- **Every assertion has an eval row.** No untestable assertions. If you can't write a check for it, the PRD is too vague — flag it.
- **Examples are positive AND negative.** At least one row in EXAMPLES shows what NOT to do, with a one-line explanation of which constraint it would violate.
- **Refusal policy is explicit.** "Don't hallucinate" is not a policy. `"If input transcript is < 100 words, respond exactly: 'I need a longer transcript to summarize.'"` is.

## Composes with

- **`/ai-feature-spec`** — the PRD section is often distilled from a larger AI feature spec; run that first to get a clean section, then feed it here.
- **`/eval-set-curator`** — hand the 5-row eval seed to the curator to expand it into a 50-row eval set with adversarial coverage.
- **`/hallucination-profiler`** — failure modes found in profiling should be folded back into this prompt's REFUSAL POLICY and negative EXAMPLES, then re-versioned (v0.2, v0.3, ...).

## License

MIT. See repo root.
