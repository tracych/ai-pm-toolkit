# ai-redteam-prompts

Generate adversarial inputs targeted at an AI feature's specific failure surface, ranked by severity x likelihood, with detection notes and a "what to fix first" triage.

## What it does

Takes a short description of an AI feature (input shape, output consumer, blast radius — who acts on the output and what goes wrong if it's hostile, wrong, or biased) and produces a defensive red-team set the engineering team can paste into a test rig today:

1. **20 concrete adversarial test prompts** spanning 8 canonical attack categories — prompt injection (direct), prompt injection (indirect via retrieved content), jailbreak / role-play to bypass refusals, PII / secret extraction, bias probes (paired prompts across demographic variants), toxic-content induction, harmful-action-as-tool (if the feature is an agent), and format-violation that breaks downstream systems.
2. **Severity x likelihood ranking** anchored to the *blast radius you describe* — the same prompt is sev 2 against a chatbot and sev 5 against an agent that can send email.
3. **Detection notes** on each row — what you would actually see if the prompt landed.
4. **A top-5 "fix-before-launch" triage list** so the team has a clear shortest path to a safer launch.
5. **A blind-spot disclaimer** — red-teaming a prompt set is not red-teaming a system. The artifact says so explicitly.

The output is one `redteam-prompts.md` in your working directory. Hand it to the engineers who own the feature.

## Use it

In Claude Code (with this repo in your workspace):

```
/ai-redteam-prompts An AI agent that reads incoming customer emails and can draft and send replies after a human approves them.
```

Or paste a longer feature description into the conversation and let the skill auto-trigger on phrasing like "red-team this AI feature", "what adversarial prompts should we test", "generate jailbreak / injection tests for X".

If you describe the feature but don't say **who consumes the output** (chatbot vs. agent vs. downstream pipeline) the skill will refuse — without blast radius, severity is meaningless.

## Output

`redteam-prompts.md` in your current working directory, containing:

- The feature description (verbatim, with the blast-radius assumptions called out)
- A **20-row prompt table** sorted by priority (severity x likelihood) with category, hypothesized failure, detection note, and 1-line mitigation
- An **8-category coverage table** so you can see at a glance whether any attack family is under-tested
- A **top-5 fix-before-launch list** distilled from the highest-priority rows
- A **"what this red-team CANNOT cover"** disclaimer (live model behavior, tool-integration failures, multi-turn drift, real attacker novelty)

## When NOT to use

- The feature isn't AI-powered — there's nothing model-specific to red-team.
- You haven't decided yet what the feature *does* — use `/ai-feature-spec` first.
- You need a full security audit including infra, auth, and supply chain — this skill covers the model-behavior surface only.
- You want to actually run the prompts against a live system — this skill produces the prompts; a test harness runs them.

## Operating principles

- **Severity is anchored to blast radius.** Same prompt against a read-only chatbot is sev 2; against an agent with an email-send tool it's sev 5. The PM's description of the output consumer drives every severity score.
- **Concrete inputs, not theoretical categories.** Every row is a paste-able test case, not a description of what *kind* of test you should write.
- **Injection / jailbreak are non-skippable.** Categories 1, 2, 3 (direct injection, indirect injection, jailbreak) each get at least 2 prompts for any LLM feature. No exceptions.
- **Bias probes come in pairs.** Same scenario, two-plus demographic variants, so the team can compare outputs directly instead of arguing about whether one output "felt biased."
- **Disclose blind spots.** Red-teaming a prompt set is not red-teaming a system. The artifact always includes the "what this CANNOT cover" section.

## Composes with

- **`/hallucination-profiler`** — failure modes it surfaces become high-quality red-team prompt seeds.
- **`/eval-set-curator`** — these red-team prompts fold into the curator's "hostile" category.
- **`/ai-feature-spec`** — the spec's failure-modes section gets richer once you've seen the red-team results.
- **`/demo-to-product-gap-auditor`** — the auditor checks whether a red-team has even been run before sign-off.

## License

MIT. See repo root.
