# Processes and rituals

> How decisions get made. The cadence of the week. Where the trains run.

## Weekly cadence

| Day | Ritual | Owner | Output |
|---|---|---|---|
| Mon | Sprint planning (30 min) | rwest | This week's commits |
| Tue/Thu | Eng standup async in chat (no meeting) | self-serve | Yesterday/today/blockers |
| Wed | Eng review (1 hr, optional) | dpark | Design feedback for in-flight work |
| Fri | Demo + retro (45 min) | rotates | Shipped work + improvements |

## Release cadence

- Master is always deployable
- Cuts on Mon/Wed/Fri at 14:00 local
- Hotfixes can cut any time with on-call approval
- Major model launches go through the A/B ramp ladder (see metrics_and_measurement.md)

## How decisions get made

Three flavors:

1. **Reversible / low-stakes** — IC decides. Document in PR description.
2. **Reversible / high-stakes** — IC writes a 1-pager. EM + tech lead sign off async in chat. 48h turnaround.
3. **Irreversible / high-stakes** — Design doc, x-team review, EM and skip-level sign off.

If unsure which flavor, default up one level.

## On-call

- Weekly rotation, Mon-Mon, all eng
- Primary handles pages, secondary covers if primary unreachable
- New on-call gets a shadow week before solo
- Pages above sev-3 trigger incident review the following Wed

## Retro format

Every other week. Three questions:
1. What worked?
2. What didn't?
3. What's one thing we'll try differently?

Action items have an owner and a date. Reviewed at next retro.

## Things that have changed recently

| Date | Change | Why |
|------|--------|-----|
| 2026-04 | Standup moved from sync to async in chat | Saved 2 hrs/wk per IC, no decision quality loss |
| 2026-03 | Eng review made optional (was mandatory) | Reduced meeting load; quality improved (only show up if you need feedback) |

## Open questions

- Bi-weekly retro is currently coupled to sprint. Should retro be monthly instead? Some ICs feel it's too frequent.

---
*Maintainer: rwest*
*Last reviewed: 2026-05-15*
