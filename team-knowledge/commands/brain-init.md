---
displayName: 'Brain — Init'
description: 'Scaffold a new team knowledge base in the current directory. Creates team-config.yaml, CLAUDE.md, contributors/, intake.md, conflict_log.md, and reports/ subfolders from templates.'
---

# /brain-init

Bootstrap a team brain. Run from the empty (or near-empty) directory you want the brain to live in — typically `~/team-brain/` or `~/brains/<team-slug>/`.

## Phase 0 — Confirm location

1. `pwd` and show the user where the brain will be created.
2. If the directory is non-empty, list contents and confirm overwrite is not desired before proceeding.
3. Ask for the **team name** (free text, e.g. "Shoplit Recommendations") and a **slug** (kebab-case, used in metadata).

## Phase 1 — Scaffold

Create this layout, copying from `templates/`:

```
./
├── team-config.yaml         # from templates/team-config.yaml.tmpl
├── CLAUDE.md                # from templates/team-brain.CLAUDE.md.tmpl
├── brain-meta.json          # generated: {name, slug, created_at, created_by}
├── contributors/            # empty — populated by /brain-ingest
├── intake.md                # from templates/intake.md.tmpl
├── conflict_log.md          # from templates/conflict_log.md.tmpl
└── reports/
    ├── _source-log/         # empty
    ├── moderated/           # empty
    └── published/           # empty
```

Fill in the team name and slug throughout the templates.

## Phase 2 — Source config walkthrough

Open `team-config.yaml` and ask the user to fill in the `roster` and `data_sources` sections. The template includes placeholders like `<chat_space_id>`, `<task_system>`, `<doc_drive_id>`. The plugin is connector-agnostic — these are just identifiers the user's own `/brain-ingest` step will read.

Stop here. Tell the user:

> Brain created at `<path>`. Next steps:
> 1. Edit `team-config.yaml` — add your roster and source identifiers
> 2. Run `/brain-ingest --since 7d` to pull the first batch
> 3. Run `/brain-evolve` to roll contributor files up into the team brain

## Phase 3 — Optional: copy the example

If the user says they want to see a worked example, copy `assets/example_brain/` into a sibling `example/` folder so they can compare structure side-by-side. Do not copy into the user's brain root.
