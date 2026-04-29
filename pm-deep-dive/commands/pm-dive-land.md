---
displayName: 'PM Dive — Land'
description: 'Feed dive findings into persistent project knowledge so the next Claude session inherits them. The high-leverage primitive other research skills lack.'
---

# /pm-dive-land

**Stage 7 of pm-deep-dive.** The differentiator. Most research skills stop at SUMMARY; this one closes the loop into persistent knowledge.

## Usage

```
/pm-dive-land --target claude-md          # default — append to project CLAUDE.md
/pm-dive-land --target knowledge-base     # append to a knowledge file path (asks for path)
```

Default `--target` is `claude-md`. Land into the project CLAUDE.md that owns this dive's folder.

## Phase 0 — Load

1. Locate dive folder, read `00_SUMMARY.md` and `frame.json`.
2. Resolve target:
   - `claude-md`: walk up from dive folder to find the nearest `CLAUDE.md`. Confirm path with user.
   - `knowledge-base`: ask user for the file path.

## Phase 1 — Generate the diff

Distill SUMMARY into a knowledge update — this is **NOT** the SUMMARY itself, but a condensed, decision-ready snippet.

Schema for the appended block:

```markdown
### {Dive title} ({date})

**Verdict:** {CONFIRMED / REFUTED / PARTIAL} — {claim}

**Key findings (HIGH confidence):**
- {finding 1, 1 line}
- {finding 2}
- {finding 3}

**Open questions worth chasing:**
- {open q with effort estimate}

**Source:** [`{dive_folder}/00_SUMMARY.md`](relative path)
```

Constraint: ≤ 15 lines per block. The CLAUDE.md grows over time; concision is a feature.

## Phase 2 — Apply with confirmation

1. Show the user the proposed diff (the new block + where it would land in the target file).
2. Suggest a section heading to land under (e.g., `## Validated Findings` if not present, create it).
3. Ask: *"Apply this diff? [y/n/edit]"*
4. On `y`: apply via Edit tool.
5. On `edit`: open the diff for user editing inline, then apply.

## Phase 3 — Telemetry (opt-in)

Append a one-line entry to `~/.claude/pm-deep-dive/dive_log.md` (create if missing):

```
{date} | {username} | {dive_slug} | verdict={verdict} | depth={depth} | landed=true
```

If file doesn't exist and user hasn't opted in, ask once: *"Track this dive in your local log for personal analytics? [y/n] (one-time question per machine)"*. Save preference to `~/.claude/pm-deep-dive/config.json`.

## Phase 4 — Hand off

Print:

> Landed: `{target_file}`
> Section: `{section_name}`
> Block size: {N lines}
>
> The next Claude session in this project will inherit this finding via CLAUDE.md.
>
> Dive complete. Files preserved in `{dive_folder}`:
> - frame.json (audit trail)
> - 01_*.md … (raw outputs)
> - validation_code.md / validation_knowledge.md (validators)
> - 00_SUMMARY.md (canonical synthesis)
> - OPEN_QUESTIONS_LOWER_CONFIDENCE.md (next-dive seeds)
> - blog_post.md / EXEC_SUMMARY.md (if shipped)

---

## Anti-patterns

- ❌ Land the entire SUMMARY into CLAUDE.md (too long — distill to ≤ 15 lines)
- ❌ Auto-apply without showing the diff
- ❌ Land into a CLAUDE.md outside the project scope (walk up only as far as the project root)
- ❌ Force telemetry — opt-in only, asked once

## Standalone use

A PM who used another research tool (or did manual notes) can write a `00_SUMMARY.md` and call `/pm-dive-land` to feed it into project knowledge. SUMMARY is the only required input.

## Why this primitive matters

Most research dies in a folder nobody opens twice. `pm-dive-land` is the step that makes findings live across sessions, projects, and the next PM who picks up the area. Persistent knowledge beats one-off reports.
