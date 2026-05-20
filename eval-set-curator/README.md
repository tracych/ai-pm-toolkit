# eval-set-curator

Turn 5 example AI feature interactions into a 50-row eval set covering the canonical edge-case categories — empty, hostile, long, multilingual, ambiguous, format-violating — with expected behavior per row.

## What it does

You have an LLM-powered feature and a handful of "happy path" examples that work. You don't have an eval set — and the team is one launch away from finding out the hard way which categories of input break it.

This skill takes 3–10 seed examples (input + expected output for each) and expands them into a balanced **50-row eval set** along 10 canonical edge-case categories:

1. Empty / minimal input
2. Maximally-long input
3. Multilingual / non-English
4. Hostile / abusive / jailbreak-attempt
5. Ambiguous (two valid interpretations)
6. Format-violating (input doesn't match expected schema)
7. Out-of-scope (request the feature shouldn't answer)
8. Edge-of-domain (technically in-scope but rare)
9. Implicit assumption (input relies on context the model doesn't have)
10. Regression-from-prior-bug (a known failure mode the team has seen)

For every row, the skill produces: the input, the category, the **expected behavior** (concrete and machine-checkable wherever possible), and **pass criteria** (regex / keyword / short LLM-judge rubric).

You get three artifacts: a JSONL file for tooling, a single-file HTML viewer to browse the set by category and mark rows pass/fail, and a markdown summary.

## Use it

In Claude Code (with this repo in your workspace):

```
/eval-set-curator
```

The skill will ask you for your seed examples interactively. Or paste them directly:

```
/eval-set-curator Feature: extracts action items from meeting transcripts.
Seed 1: input="...", expected="..."
Seed 2: ...
```

If you provide fewer than 3 seed examples, the skill will refuse and ask for more — you need at least 3 to extract a pattern worth expanding.

## Output

`eval-set-curator/sets/<slug>/` containing:

- **`eval-set.jsonl`** — 50 rows, one per line, ready for any eval harness.
- **`eval-set.html`** — single-file viewer. Filter by category, mark rows pass/fail, persists to localStorage.
- **`eval-set.md`** — human-readable summary: category distribution + 5 sample rows per category.

## When NOT to use

- You already have a well-loved eval set with coverage you trust — just keep using it.
- You're at the prompt-iteration stage and haven't shipped a v1 yet — write the prompt first with `/prd-to-prompt`, then come here.
- You want failure-mode discovery, not test cases — use `/hallucination-profiler`.

## Operating principles

- **Balanced coverage.** Five rows per category, exactly 50. The categories that are easy to generate (empty, long) are not allowed to crowd out the ones that matter most (hostile, out-of-scope).
- **Concrete and machine-checkable.** "Refuses politely" is not pass criteria. "Output contains the phrase `I can't help with that`" is.
- **Hostile and out-of-scope are non-skippable.** Teams under-test these by default. The skill will not let you skip them.
- **LLM-judge rubrics stay short.** Under 5 lines, binary pass criterion. Long rubrics are noisy and the team won't run them.
- **No fabricated regressions.** The regression-from-prior-bug category requires the user to provide at least one known failure. If they don't, that category is left at 0 rows and flagged — don't invent bugs.

## Composes with

- **`/ai-feature-spec`** — the 5-row seed in your AI feature spec is the input here. Spec first, then eval set.
- **`/hallucination-profiler`** — discovered failure modes map directly to edge-case categories in this set.
- **`/prd-to-prompt`** — the assertions block in the generated prompt becomes pass criteria in the eval rows.
- **`/ai-redteam-prompts`** — generated red-team prompts can be folded into the hostile / jailbreak category for deeper coverage.

## License

MIT. See repo root.
