# Changelog

All notable changes to `pm-deep-dive`.

## [0.1.0] — 2026-04-28

Initial public release.

### Added
- 5-stage pipeline: `/pm-dive-frame` → `/pm-dive-run` → `/pm-dive-summarize` → `/pm-dive-ship` → `/pm-dive-land`
- `/pm-deep-dive` orchestrator that chains the five primitives with PM-in-the-loop checkpoints
- `pm-deep-dive` skill (SKILL.md) for routing PM research requests to the right primitive
- 5 domain presets (`ads`, `creator`, `integrity`, `infra`, `commerce`) plus `other` generic fallback in `assets/domain_angles.md`
- `domain_maturity` field (`established` / `new_bet`) gating the validator and confidence bar
- `user_research` angle in every preset
- Adversarial validators (refute-by-default) — code validator and knowledge re-validator — in `assets/adversarial_prompts.md`
- HIGH≥3 cross-validation rubric in `assets/confidence_rubric.md`
- Two synthetic example dives in `assets/examples/` showing what good output looks like
- `--format post` (blog post) and `--format exec` (1-page executive brief) ship targets
- `--target claude-md` and `--target knowledge-base` land targets for persistent project knowledge
- Opt-in local telemetry log at `~/.claude/pm-deep-dive/dive_log.md`
