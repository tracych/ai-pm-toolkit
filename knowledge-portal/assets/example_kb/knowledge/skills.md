# Skills

> AI/automation skills the team uses. Slash commands, shared prompts, agents. The "what tools do we have" page.

## Shared slash commands

| Command | What it does | Owner |
|---|---|---|
| `/team-status` | Pulls the last week of activity per team member into a summary | dpark |
| `/eval-readout` | Drafts an A/B readout from raw experiment data | mchen |
| `/incident-summary` | Generates a sev review template from a page transcript | dpark |
| `/spec-skeleton` | Drops a design-doc skeleton with our standard sections | rwest |

## Shared prompts

Lives in the team's prompt library (linked in `resources.md`). The four that get reused most:

| Prompt | When to use |
|---|---|
| "Adversarial design review" | Before posting a design doc — paste, get devil's-advocate critique |
| "PR description from diff" | Generate first-draft PR description from a unified diff |
| "Standup phrasing" | Compress a paragraph of standup into 2-3 bullets |
| "Stakeholder-friendly explainer" | Convert a technical note into a non-engineer-readable version |

## Agents

We use one MCP server: a read-only one that exposes our experiment platform. Used inside `/eval-readout` to pull metric deltas. No write paths — safer that way.

## What's NOT on this page

- Personal productivity prompts (use yourself, don't centralize)
- One-off scripts for specific projects (live in the project folder, not here)
- External AI products we use as humans (ChatGPT, Claude.ai, etc.) — those aren't team skills

## Things that have changed recently

| Date | Change | Why |
|------|--------|-----|
| 2026-05 | Added `/eval-readout` | Replaced a manual checklist that was taking ~2 hrs/launch |
| 2026-04 | Retired the "Slack TL;DR" slash command | Generated summaries that nobody read |

## Open questions

- Should we standardize on a single model for shared prompts? Currently mixed.

---
*Maintainer: rwest*
*Last reviewed: 2026-05-10*
