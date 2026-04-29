# pm-deep-dive

> Multi-agent PM research methodology, encoded as a Claude Code skill.

For PMs **ramping into a new domain** or **pressure-testing a strategic claim**. Frame a falsifiable question, run parallel research agents across orthogonal angles, adversarially validate the claims, synthesize with cross-validation, ship a post or exec brief, and land findings into persistent project knowledge so the next session inherits them.

**Pattern origin:** built from real product work — 8 multi-agent dives across a 5-week domain ramp, where adversarial code validation caught 2 reversed claims that would otherwise have shipped to leadership.

---

## Install

Clone the repo, then symlink the plugin into Claude Code's plugin directory:

```bash
# Pick a stable location for the clone (e.g. ~/code/)
cd ~/code
git clone https://github.com/tracych/ai-pm-toolkit.git

# Link the plugin directory into Claude Code
mkdir -p ~/.claude/plugins
ln -s ~/code/ai-pm-toolkit/pm-deep-dive ~/.claude/plugins/pm-deep-dive
```

Or copy `pm-deep-dive/` into `~/.claude/plugins/` directly (loses the ability to `git pull` updates).

Restart Claude Code. The `/pm-deep-dive`, `/pm-dive-frame`, etc. slash commands should appear.

---

## Quickstart (5 minutes)

```bash
# Run the orchestrator end-to-end
/pm-deep-dive

# Or run primitives individually
/pm-dive-frame              # turn a topic into a falsifiable claim + angles
/pm-dive-run                # spawn parallel research + adversarial validators
/pm-dive-summarize          # cross-validation matrix + verdict
/pm-dive-ship --format post # productize as blog post or exec brief
/pm-dive-land               # feed findings into project CLAUDE.md
```

The five primitives compose. Frame once, run, then iterate on summarize / ship / land without re-running agents.

---

## What it does

| Stage | Command | Output |
|---|---|---|
| 1. Frame | `/pm-dive-frame` | `frame.json` — claim, audience, depth, confirmed angles |
| 2. Run | `/pm-dive-run` | `01_*.md` … `06_*.md` raw outputs + `validation_code.md` / `validation_knowledge.md` |
| 3. Summarize | `/pm-dive-summarize` | `00_SUMMARY.md` + `OPEN_QUESTIONS_LOWER_CONFIDENCE.md` |
| 4. Ship | `/pm-dive-ship` | Blog post / exec brief from SUMMARY |
| 5. Land | `/pm-dive-land` | Diff applied to project `CLAUDE.md` or knowledge base |

Reads as a sentence: **frame → run → summarize → ship → land.**

---

## When to use it

- Ramping into a new domain and need breadth + structure fast
- Pressure-testing a strategic claim before taking it to leadership
- Investigating a falsifiable question you can phrase as "X is whitespace" / "Y is the bottleneck" / "we should partner with Z"

## When NOT to use it

- One-shot factual lookups → use a web search or doc lookup directly
- You already have HIGH-confidence priors → just write the doc
- The question can't be phrased as a falsifiable claim → reframe first
- Generic "deep research" without PM framing → use a generic deep-research skill instead

---

## Composes with

This skill stands on the shoulders of the broader Claude Code ecosystem:
- **Generic parallel multi-agent research skills** — `pm-dive-run` adapts that pattern with PM dive folder conventions
- **Cross-validation / triple-check skills** — `pm-dive-summarize` adapts that pattern for the PM HIGH≥3 confidence rubric

`pm-deep-dive` adds: PM-specific framing, claim verdicts, productization (post/exec brief), and persistent knowledge feedback — the parts generic research skills don't cover.

---

## Examples

Two synthetic dives in `assets/examples/`:
- **`synthetic_ramp_dive/`** — onboarding-mode breadth across an unfamiliar domain
- **`synthetic_claim_dive/`** — depth pressure-testing one falsifiable claim

Read `00_SUMMARY.md` in each to see what good looks like.

---

## Extending

- **Add a domain preset**: edit `assets/domain_angles.md`, add a section, PR back
- **Customize templates**: copy `assets/templates/` into your project, modify
- **Tune confidence rubric**: `assets/confidence_rubric.md`

Domain presets shipped: ads, creator, integrity, infra, commerce, plus an `other` generic fallback. Every preset includes a `user_research` angle.

---

## Feedback

- **Bugs / requests / discussion**: open an issue on [GitHub](https://github.com/tracych/ai-pm-toolkit/issues)
- **Telemetry**: opt-in, entirely local. `/pm-dive-land` asks once per machine whether to append a one-line entry per dive (date, verdict, depth, dive slug) to `~/.claude/pm-deep-dive/dive_log.md`. Preference is stored in `~/.claude/pm-deep-dive/config.json`. To opt out later, delete `config.json` (you'll be asked again next run) or `dive_log.md` (history wiped). Nothing is ever sent off your machine.

---

## Roadmap

- **v0.1** (current) — initial public release: 5-stage pipeline, 5 domain presets + `other` fallback, `domain_maturity` gating the validator and confidence bar
- **v0.2** (planned) — `--validate-only` re-run, custom per-project templates, ramp-mode breadth tier
- **v0.3** (planned) — `--format html` interactive explainers, more domain presets (growth, B2B, hardware, research)

---

## License

MIT. See `LICENSE` in the repo root.
