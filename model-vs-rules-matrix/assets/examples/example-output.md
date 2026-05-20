# Model vs Rules vs Hybrid — support-ticket-routing

## Feature
> Auto-categorize inbound customer support tickets into 12 product-area buckets (Billing, Auth, Mobile-iOS, Mobile-Android, Web, API, Integrations, Notifications, Search, Admin, Reporting, Other) and route each to the right team queue within 30 seconds of submission. Volume: ~80,000 tickets/day. Wrong routing means a 4–24h delay before a human reassigns; no direct user harm or money impact, but it tanks our first-response SLA.

**Stakes:** convenience (leaning operational) — wrong routes delay response but don't move money, harm users, or affect moderation. Failure-recovery is reversible via human reassignment.

## Matrix

| Dimension | Pure-model (LLM classifier) | Pure-rules (keyword + regex table) | Hybrid (rules cheap-path → LLM fallback) |
|-----------|------------------------------|-------------------------------------|-------------------------------------------|
| Cost-at-scale | 2 — At 80k tickets/day, a small-model classify call (~$0.001 each) is ~$2.4k/mo; acceptable but grows linearly. | 5 — Sub-millicent per ticket; cost is the one-time rule-authoring sprint. | 4 — Rules handle ~65–75% of tickets free; LLM only fires on the ambiguous tail (~$700/mo). |
| p95-latency | 3 — Single LLM call at p95 is ~1.5–3s; well within the 30s budget but vulnerable to provider blips. | 5 — Regex+lookup runs in <50ms p95 with no external dependency. | 5 — Rules path returns in <50ms for the cheap-path majority; LLM tail still well inside 30s. |
| Explainability | 2 — Can show the input ticket and the predicted label, but "why Billing not Admin?" requires speculative rationalization. | 5 — Every routed ticket cites the exact rule + matched phrase; support leads can audit and edit the rule live. | 4 — Rules-routed tickets are fully explainable; LLM-routed tail inherits the opaque-label problem but is a known minority. |
| Maintainability | 3 — New product area = re-prompt + re-eval; taxonomy drift requires periodic prompt/few-shot updates and an eval set. | 2 — 12 buckets × evolving product vocabulary = rule sprawl; every new feature launch needs a rule PR; risk of conflicting rules. | 4 — Rules cover the stable high-volume vocabulary; the LLM absorbs new terminology without rule edits until volume justifies promoting a rule. |
| Failure-recovery | 3 — Mis-routes are detectable via the human-reassignment signal but require eval-set updates or prompt tweaks to fix; rollback = revert prompt version. | 5 — A bad rule is a one-line revert; mis-routes are loud (matched-rule field in the ticket) and trivially reversible. | 4 — Rules failures are cheap to revert; LLM failures require the same prompt-tweak loop but affect only the tail. |

**Totals:** Pure-model 13/25 · Pure-rules 22/25 · Hybrid 21/25
**Point winner:** Pure-rules (22/25)
**Load-bearing cells:**
- Pure-rules **Maintainability = 2** — the dealbreaker risk if the product taxonomy keeps churning.
- Pure-model **Explainability = 2** and **Cost = 2** — two dealbreaker cells; even though stakes are only "convenience," the explainability gap hurts support-lead trust in the system.
- Widest spread: **Cost-at-scale** (2 → 5 → 4). The recommendation hinges on whether the team is willing to spend ~$2.4k/mo to skip the rule-authoring sprint.

## Recommendation

**Ship hybrid (21/25) — not the point winner, but the durable answer.** Pure-rules wins on points (22) because today's vocabulary is tractable as keywords, but the **Maintainability = 2** cell is a slow-motion fire: 12 buckets × an evolving product vocabulary means the rule table will sprawl every quarter and someone will own a thankless rule-PR cadence forever. Hybrid keeps the cheap-path rules where they earn their keep (sub-50ms p95, fully explainable, ~65–75% coverage) and uses the LLM only on the ambiguous tail — absorbing new product terminology without rule edits and capping LLM spend at ~$700/mo. The trade-off the PM is accepting: ~$700/mo and a small opaque tail of LLM-routed tickets, in exchange for not owning a perpetual rule-maintenance backlog. Stakes are "convenience" so the pure-model explainability gap doesn't trigger the override, but it does justify keeping the rules cheap-path as the explainable majority of traffic.

## Switch your answer if

- **Switch to pure-rules if:** the product taxonomy freezes for the next 4 quarters (e.g., a code-freeze on new product areas, or a stable product line). *Why:* the Maintainability cell on pure-rules flips from 2 to 4, making the 22/25 total durable and the ~$700/mo LLM spend unjustifiable.
- **Switch to pure-model if:** ticket volume drops below ~10k/day AND the bucket count grows past ~25. *Why:* Cost-at-scale on pure-model rises from 2 to 4 (small absolute spend), and Maintainability on pure-rules drops from 2 to 1 (25+ buckets is unworkable as a hand-authored table).

## Rules-first MVP

**What ships:** a keyword + regex classifier with ~15–25 rules per bucket, built as a YAML table (`bucket: [regex_patterns]`) evaluated in priority order. Each rule records the matched pattern on the ticket so support leads can audit and edit live. Default bucket on no-match: `Other`, which routes to a small triage queue.

**What it deliberately doesn't do:** handle tickets where the user describes the symptom without product vocabulary ("the thing won't load"), tickets that span two buckets (Billing + Mobile-iOS), or non-English tickets beyond what regex tolerates. These fall to `Other` and the triage queue handles them.

**Coverage estimate:** ~65–75% of tickets correctly routed in v1 (assumption: ~70% of inbound tickets contain at least one product-area keyword in the first 200 characters — confirm with a one-day sample of historical tickets before building).

**Promote to model when:** the `Other` queue exceeds ~25% of daily volume for two consecutive weeks, OR a support lead requests >10 new rules in a single week (signal that the taxonomy is outgrowing hand-authored rules), OR a new product area launches and rule coverage for it lags >2 weeks behind launch.

## Notes

- The "Stakes: convenience" classification is the load-bearing assumption. If wrong routing escalates to (e.g.) a contract-breach SLA penalty, re-classify as money and re-score — pure-model's explainability gap then becomes a louder flag.
- The ~$2.4k/mo and ~$700/mo cost figures assume a small-model classifier at ~$0.001/call; re-budget with `/cost-latency-budgeter` before committing.
- A one-day sample of historical tickets is a near-zero-cost de-risking step before picking between hybrid and rules-first MVP — recommend running it first.
