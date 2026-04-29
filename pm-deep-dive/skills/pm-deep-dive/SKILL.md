---
name: pm-deep-dive
description: |
  PM-specific multi-agent research methodology for ramping into a new domain or pressure-testing a strategic claim. Use when the request matches PM research framing — the user wants to: investigate a falsifiable claim ("X is whitespace", "Y is the bottleneck"), ramp into an unfamiliar product/technical domain, build a competitive landscape with cross-validation, or pressure-test a strategy hypothesis before bringing it to leadership. Triggers on language like "deep dive", "investigate this claim", "pressure-test", "PM ramp", "competitive landscape for [product]", "is X whitespace", "cross-validate this finding".

  Do NOT trigger for: generic deep research without a PM-flavored decision attached (use a generic deep-research skill instead), one-shot factual lookups (use a web search directly), pure engineering investigations (use a generic deep-research or triple-check skill), or when the user already has HIGH-confidence priors and just wants to write a doc.
---

# pm-deep-dive (skill)

When the user's request matches PM research framing, suggest the appropriate command:

| User intent | Suggest |
|---|---|
| "Help me deep-dive into X" / "I want to investigate X" | `/pm-deep-dive` (full orchestrator) |
| "I have a claim, help me frame it" | `/pm-dive-frame` |
| "I have angles, run the agents" | `/pm-dive-run` |
| "I have raw research, synthesize it" | `/pm-dive-summarize` |
| "Turn this into a blog post / exec brief" | `/pm-dive-ship` |
| "Save these findings to project knowledge" | `/pm-dive-land` |

## How this skill differs from adjacent skills

- **Generic deep-research skills** — generic parallel research; this skill adds PM framing, claim verdicts, productization, and knowledge feedback
- **Cross-validation / triple-check skills** — cross-validation primitive; this skill wraps that pattern inside a PM workflow
- **Work-summary / past-work-synthesis skills** — those summarize what has already happened; this skill is for *new* domain investigation

## When in doubt

Run `/pm-deep-dive` and let the orchestrator route. PMs new to the skill should start there.

See `README.md` and `assets/examples/` for methodology and worked examples.
