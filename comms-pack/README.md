# comms-pack

One launch brief in. Six audience-tuned comms artifacts out — plus a single-file HTML preview that tabs across all of them.

## What it does

From a single launch brief paragraph, generate the full routine launch comms set in one pass:

1. **release-notes** — public-facing, What / Why it matters / Get started
2. **internal** — team announcement, what shipped + who to thank + what's next
3. **exec-update** — business-impact bullets + one ask
4. **customer-email** — friendly subject + body + CTA
5. **social** — ≤280 chars, hook + value + CTA
6. **faq** — 8 Q&A pairs (4 common, 4 sharp-edge)

Then bundles all six into an `index.html` preview with tabs (zero CDN, opens offline) so you can scan the whole pack before sending anything.

The skill also runs a "what claim here can't you defend?" pass on the exec + customer artifacts and flags weak claims inline with `[NEEDS EVIDENCE: ...]`.

## Use it

In Claude Code (with this repo in your workspace):

```
/comms-pack We're shipping autosave for shared docs to all paid workspaces on May 28. Cuts data-loss incidents reported by support by ~40% in beta. Available on web and desktop; mobile rolls out in June.
```

Optional audience filter — pass a comma list to generate a subset:

```
/comms-pack [exec-update,customer-email,faq] <brief>
```

If the brief is under 20 words, comms-pack refuses and asks for more substance. Light briefs ship light comms.

## Output

Lands in `comms-pack/<slug>/`:

```
comms-pack/<slug>/
  release-notes.md
  internal.md
  exec-update.md
  customer-email.md
  social.md
  faq.md
  index.html        ← tabbed preview of all six, opens in any browser
```

Open `index.html` in any browser — no server, no install. Header shows a "draft — review before sending" pill so nobody mistakes a preview for an approval.

## When NOT to use

- Incident or rollback comms — use `rollback-planner` (different shape, different rules).
- A single artifact you already know is the only one you need — write it yourself, it's faster.
- Comms that need legal/PR sign-off as the primary input — start with the reviewer, not the generator.
- Brand-voice-critical surfaces (homepage, brand campaigns) — use your in-house copy team.

## Operating principles

- **One brief, six voices.** Same facts, six different framings. Exec ≠ customer ≠ social — if they read the same, the pack failed.
- **Flag what you can't defend.** Any claim in the exec or customer artifact that the brief doesn't support gets a visible `[NEEDS EVIDENCE: ...]` marker. Better an honest gap than a confident lie.
- **Preview before send.** Every pack ships with an `index.html` tabbed preview so a human eyeballs the whole set in one shot.
- **Refuse thin briefs.** Under 20 words → no comms. Garbage in, garbage out, and comms blast radius is too big to guess.
- **Plain markdown + plain HTML.** No frameworks, no CDN, no dependencies. Copy-pasteable into any tool.

## Composes with

- **protopilot** — use the PM notes from a protopilot prototype as the seed brief for comms-pack.
- **retro-facilitator** — close the launch loop a week after shipping; comms-pack ships the launch, retro-facilitator processes what actually happened.
- **rollback-planner** — rollback-planner ships 3 incident comms (status, customer apology, postmortem). comms-pack ships the 6 routine launch comms. Complementary, not overlapping.

## License

MIT.
