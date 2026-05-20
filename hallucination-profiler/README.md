# hallucination-profiler

For an LLM-powered feature, enumerate the top hallucination and failure modes specific to its input/output shape, with detection strategies and user-facing mitigations.

## What it does

Takes a description of an LLM-powered feature — input shape, output shape, who consumes the output, and blast radius — and produces a ranked profile of the 7 most likely hallucination and failure modes, drawn from a canonical taxonomy of 12. For each chosen mode it returns:

1. A 1-line **definition** of the failure mode.
2. **Why it's likely here**, tied to the specific feature shape (not a generic risk register).
3. **Severity (1–5) × Likelihood (1–5) → Priority** score, used to rank.
4. A **detection strategy** — automated check, LLM-as-judge, or human review — concrete enough to spec.
5. A **user-facing mitigation** — both the copy and the UX pattern (banner, citation, edit-first, confirm step, etc.).

Ends with a **"what to instrument from day 1"** list of exactly 3 metrics so the failure modes are measurable from the first build.

The output is one `hallucination-profile.md` in your working directory. Hand it to engineering for the eval set, to design for the mitigation copy, and to whoever runs your launch review.

## Use it

In Claude Code (with this repo in your workspace):

```
/hallucination-profiler Feature: an LLM that drafts replies to customer support emails. Input: the customer's email thread + the account's recent order history. Output: a suggested reply email. Consumer: support agent who edits before sending. Blast radius: one customer per send.
```

Or paste a feature spec into the conversation and let the skill auto-trigger on phrasing like "what could go wrong with this LLM feature", "hallucination risks for this AI feature", "failure modes for our AI feature".

If your input is missing any of (a) input shape, (b) output shape, (c) who consumes the output — the skill will refuse and ask for the missing piece. A failure profile against unknown shape is astrology.

## Output

`hallucination-profile.md` in your current working directory, containing:

- The feature summary (input shape / output shape / consumer / blast radius)
- A ranked table of the **top 7 failure modes** with severity × likelihood × priority
- One section per failure mode (definition, why likely here, detection, mitigation copy + UX)
- A **day-1 instrumentation** list of 3 metrics
- A short note on which 5 of the 12 canonical modes were deprioritized, and why

## When NOT to use

- Your feature does not involve an LLM in the response path — generic risk registers do that job.
- You haven't decided the output shape yet — go define it, then come back. The profile is shape-specific.
- You need a model evaluation methodology, not a risk surface — use a proper eval framework.
- You're past launch and debugging a specific failure — use a postmortem, not a pre-build profile.

## Operating principles

- **Tie every failure mode to the feature's actual input/output shape.** Generic risk lists are useless. "Hallucination is bad" is not a finding.
- **Rank by severity × likelihood, not alphabetically.** PMs need a priority order, not a checklist. The top of the list is where to spend the eval budget.
- **Every failure mode gets BOTH a detection strategy AND a user-facing mitigation.** Detection without UX is a dashboard nobody reads. UX without detection is theater.
- **Distinguish hallucination from failure.** Hallucination = model invents. Failure = model refuses, drifts, or mis-formats. Both ship as bugs; both go in the profile.
- **Day-1 instrumentation is mandatory.** If you can't measure the failure mode, the mitigation is theater. The profile names 3 metrics that the team can log from the first build.

## Composes with

- **`/ai-redteam-prompts`** — turn the top failure modes from this profile into concrete adversarial test inputs.
- **`/eval-set-curator`** — failure modes become row categories in the eval set; severity × likelihood becomes row weights.
- **`/ai-feature-spec`** — failure modes drop straight into the spec's failure-modes section with their mitigations.

## License

MIT. See repo root.
