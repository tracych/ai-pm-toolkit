# model-capability-mapper

Given a product idea, map which AI model families plausibly enable it, where the capability cliffs are, and what "cannot do this yet" boundaries you'll hit.

## What it does

Takes a one-paragraph product idea and runs it through a model-family triage:

1. **Maps** the idea onto a fixed matrix of 10 model families (LLM-frontier, LLM-open, vision-LLM, speech, recsys/ranking, world-models, 3D-generative, agents-with-tools, embeddings/retrieval, classical-ML), marking each as **ENABLES / PARTIALLY-ENABLES / CANNOT-YET / NOT-RELEVANT** with a one-line reason.
2. **Identifies** the 3 hardest capability cliffs the idea sits near (e.g., "needs reliable long-context multi-step reasoning — current frontier models still drift after ~5 steps").
3. **Recommends** one primary model family + one fallback + the cheapest experiment that would resolve the biggest cliff in under a week.

The output is one `model-capability-map.md` in your working directory. Use it to decide what to prototype against, what to wait on, and what to never build.

## Use it

In Claude Code (with this repo in your workspace):

```
/model-capability-mapper An AI tutor that watches a student solve geometry problems on a tablet and gives them targeted feedback after each step
```

Or paste a paragraph-length idea into the conversation and let the skill auto-trigger on phrasing like "what model could do this?", "which AI family fits?", "is this feasible with current models?".

If your input is fewer than 15 words, the skill will refuse and ask you to elaborate — too vague to map.

## Output

`model-capability-map.md` in your current working directory, containing:

- The original idea (verbatim)
- A 10-row capability matrix (family × verdict × reason)
- The 3 capability cliffs the idea sits near
- A recommended primary model family + one fallback
- A "resolver experiment" that produces a yes/no answer in < 1 week

## When NOT to use

- You already know which model family you're building on — go straight to `/cost-latency-budgeter` or prototype.
- You're debugging a live model's behavior — this is a triage tool for *new* ideas, not a diagnostic for shipped systems.
- You want vendor recommendations — this tool names families, not vendors. Capability shifts faster than vendor names.

## Operating principles

- **Anchor on capability cliffs, not hype.** If frontier models can't reliably do something today, say so — even if a demo exists.
- **Name the model family, not the vendor.** "Frontier LLM" ages better than any product name.
- **One primary, one fallback — no five-option hedges.** PMs need a decision, not a menu.
- **Resolver experiments must produce a yes/no answer in under a week.** If the test would take a quarter, it's not a resolver — it's a roadmap.
- **Never invent benchmarks.** If you cite a limit, say "as of [current model generation]" and avoid specific percentages unless they're well-known.

## Composes with

- **`/problem-statement-doctor`** — run first to tighten the idea into a crisp paragraph before mapping; vague problems produce vague maps.
- **`/cost-latency-budgeter`** — once you've picked a primary family, budget its tokens, latency, and unit economics.

## License

MIT. See repo root.
