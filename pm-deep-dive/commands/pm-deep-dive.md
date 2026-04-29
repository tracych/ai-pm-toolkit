---
displayName: 'PM Deep Dive'
description: 'Orchestrator — runs the full pm-deep-dive pipeline end-to-end: frame → run → summarize → ship → land. Stops between stages so the PM stays in the loop.'
---

# /pm-deep-dive

End-to-end orchestrator. Chains the 5 primitives with PM-in-the-loop checkpoints between each.

For composability, prefer the individual primitives (`/pm-dive-frame`, `/pm-dive-run`, `/pm-dive-summarize`, `/pm-dive-ship`, `/pm-dive-land`). Use this orchestrator when you want the full guided experience.

## Pipeline

```
/pm-dive-frame      → frame.json
       ↓ confirm
/pm-dive-run        → 01_*.md … 06_*.md + validation_code.md / validation_knowledge.md
       ↓ confirm
/pm-dive-summarize  → 00_SUMMARY.md + OPEN_QUESTIONS_LOWER_CONFIDENCE.md
       ↓ ask: ship? land? stop?
/pm-dive-ship       → blog_post.md / EXEC_SUMMARY.md (optional)
       ↓
/pm-dive-land       → diff applied to project CLAUDE.md (optional)
```

## Behavior

1. **Run `/pm-dive-frame`** — wait for user to confirm angles before proceeding.
2. **Show frame summary, ask: "Run agents now?"** — user can edit `frame.json` before continuing.
3. **Run `/pm-dive-run`** — show progress, wait for completion.
4. **Run `/pm-dive-summarize`** — print verdict + top findings.
5. **Stop and ask the user**:
   > Dive complete through synthesis. Verdict: {verdict}.
   >
   > What next?
   > - `ship` — productize as blog post or exec brief
   > - `land` — feed findings into project CLAUDE.md
   > - `both` — ship then land
   > - `stop` — done, SUMMARY is the deliverable
6. Run user's choice, or stop.

## Why stop between stages

- The PM may want to edit angles after framing
- After agents return, the PM may want to spot-check a single output before synthesizing
- After SUMMARY, the PM decides what to productize — this is judgment, not automation

## Anti-patterns

- ❌ Auto-run all stages without checkpoints
- ❌ Auto-ship and auto-land without asking
- ❌ Hide intermediate failures (validator gap, agent crash) to keep the pipeline flowing

## Composes with

- All five primitives — this orchestrator just chains them
- Standalone primitives if the PM wants finer control or skips a stage
