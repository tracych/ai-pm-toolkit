---
displayName: 'PM Dive — Frame'
description: 'Turn a PM topic or draft claim into a falsifiable claim + 5-6 orthogonal research angles. Outputs frame.json — the seam every downstream pm-dive-* command reads.'
---

# /pm-dive-frame

**Stage 1–2 of pm-deep-dive.** Frame the question and decompose it into angles. Produces `frame.json` — the contract every downstream primitive (`/pm-dive-run`, `/pm-dive-summarize`, `/pm-dive-ship`, `/pm-dive-land`) reads to know what dive is in flight.

## Design principle

Pre-commit the question as a falsifiable claim, then commit to 5–6 orthogonal angles **before** spawning any agents. Angle quality drives output quality more than agent prompt quality. Cross-validation is only meaningful if angles are truly independent.

Also pre-commit to **domain maturity** — established (code/data exists, can be validated against the codebase) vs. new_bet (0→1, code may not exist yet, validator behaves differently). This decides the validation bar in `/pm-dive-summarize`.

## Phase 0 — Context + pre-flight

1. Identify the user (e.g. `whoami` on macOS/Linux, `$env:USERNAME` on Windows).
2. Read root `CLAUDE.md` (if present) to pick up active projects and team context.
3. Ask which project this dive belongs to, or propose a default folder under the user's project root.
4. **Pre-flight tool health check** (best-effort, do not block on failure). Probe:
   - `Grep` with a trivial query against the project root
   - `WebFetch` against a known-good URL
   - If either probe errors, warn: *"Code/knowledge validation in `/pm-dive-run` will be degraded. Continue anyway?"*
   - If both tools were already used in this session (visible in tool history), skip probes and mark `tool_health.*: "ok"`.

## Phase 1 — Pre-commit the claim

Prompt the user:

> What's the question? Phrase it as a **falsifiable claim** if you can — e.g.:
> - "Post-purchase satisfaction is whitespace in our domain"
> - "Sparse signals are the binding constraint on quality models"
> - "Our team should partner with X team on Y"
>
> If you only have a topic, give it to me and I'll propose 2–3 candidate claims for you to pick from.
>
> Also tell me:
> - **Audience** for the eventual deliverable: `pm-self` / `pm-peers` / `xfn` / `leadership`
> - **Depth**: `quick` (3 agents, no validation) / `standard` (5–6 agents + 1 validation pass) / `deep` (5–6 agents + 2 validation passes)
> - **Domain hint**: `ads` / `creator` / `integrity` / `infra` / `commerce` / `other`
> - **Domain maturity**: `established` (mature area where code, systems, and data exist — code/data validation is meaningful) / `new_bet` (0→1 area where absence of code is the *expected* state — code validator will be skipped, HIGH confidence is angle-agreement-based)

If the user gives a topic without a claim, propose 2–3 candidate falsifiable claims and ask them to pick or refine. Do not proceed without a claim.

If the user is unsure about maturity, ask: *"If you searched the codebase for the core systems your claim references, would you expect to find them?"* Yes → `established`. No / "we're inventing this" → `new_bet`. When unsure, default to `established` (more rigorous bar).

## Phase 2 — Interactive angle decomposition

**Critical step. Do not skip user confirmation.**

Read `assets/domain_angles.md` and load the preset matching the domain hint. Propose **5–6 orthogonal angles** as a numbered list (every preset includes a `user_research` angle as the 6th — keep it unless the claim is genuinely user-independent). If domain is `other`, use the `other` preset.

Present:

> Here are the angles I'd run. Confirm, edit, or swap any:
> 1. ...
> 2. ...
> Do these decompose the question well? Any angle missing? Any redundant?

**Wait for explicit confirmation before writing `frame.json`.**

## Phase 3 — Write frame.json

Save to `{dive_folder}/frame.json` with this exact schema:

```json
{
  "version": "0.2",
  "claim": "string — the falsifiable claim, exact wording",
  "audience": "pm-self | pm-peers | xfn | leadership",
  "depth": "quick | standard | deep",
  "domain": "ads | creator | integrity | infra | commerce | other",
  "domain_maturity": "established | new_bet",
  "angles": [
    {
      "id": "01",
      "name": "string — short slug, snake_case",
      "instruction": "string — angle-specific job for the agent"
    }
  ],
  "dive_folder": "absolute path",
  "created_by": "username",
  "created_at": "YYYY-MM-DD",
  "tool_health": {
    "code_search": "ok | degraded | failed",
    "web_fetch": "ok | degraded | failed"
  }
}
```

If `domain_maturity` is absent, downstream commands default to `established` (the more rigorous bar).

Also create the dive folder skeleton:
```
{project}/research/{dive_slug}/
├── frame.json
└── (downstream primitives populate the rest)
```

`{dive_slug}` = first 3–4 words of the claim, snake_case, ≤ 40 chars. Examples:
- *"Post-purchase satisfaction is whitespace in our domain"* → `post_purchase_satisfaction_whitespace`
- *"Sparse signals are the binding constraint on quality models"* → `sparse_signals_binding_constraint`
- *"Our team should partner with the Growth org on user acquisition"* → `partner_with_growth_on_acquisition`

## Phase 4 — Hand off

Print to user:

> Frame saved: `{dive_folder}/frame.json`
> Claim: {claim}
> Angles: {N angles, depth tier}
> Domain maturity: {established | new_bet} — {validator will check code/data | code validator skipped, knowledge re-validation only}
> Tool health: {summary}
>
> Next: `/pm-dive-run` to spawn agents, or edit `frame.json` directly to adjust.

**Do not auto-spawn agents.** The user may want to edit angles before running.

---

## Anti-patterns

- ❌ Spawn agents in this command (that's `/pm-dive-run`'s job)
- ❌ Accept a topic without converting to a claim
- ❌ Skip user confirmation on angle decomposition
- ❌ Write `frame.json` with placeholder angles you didn't actually present
- ❌ Block on tool-health failure — warn, let user proceed

## Composes with

- Downstream: `/pm-dive-run` reads `frame.json`
- Standalone use: a PM with their own framing process can write `frame.json` by hand and skip straight to `/pm-dive-run`
