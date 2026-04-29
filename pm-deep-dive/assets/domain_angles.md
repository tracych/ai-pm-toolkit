# Domain angle presets

Read by `/pm-dive-frame`. Each preset gives 4–5 orthogonal angles for a PM domain. Add new domains by appending a section.

## Schema

Each angle has:
- **Name** — short slug, snake_case, becomes the angle file name (`01_<name>.md`)
- **Instruction** — angle-specific job for the research agent (1–3 sentences)

Angles must be **orthogonal** — each agent should be able to do its job without depending on another's output.

---

## ads

Ranking, quality, monetization, signals.

1. **industry_competitive** — Industry / competitive landscape. Public sources, academic papers, competitor product announcements.
2. **internal_owners** — Internal owners, recent shipped work, active wikis, in-flight PRs related to the claim.
3. **problem_framing** — Taxonomy and decomposition of the problem space. Root causes, related sub-problems, what's been tried.
4. **measurement** — Eval methodology, A/B caveats, metric integrity. How would we know if the claim is true?
5. **adjacent_tech** — Emerging tech the domain hasn't priced in (new model architectures, new data sources, new infra capabilities).
6. **user_research** — UXR / surveys / qualitative interviews on user perception of ads quality, what "low quality" means to users, behavioral signals beyond X-out / report.

---

## creator

Creator tools, content creation, consumer product.

1. **industry_competitive** — Competitor product landscape (Roblox, Unity, Unreal, TikTok, etc.).
2. **internal_owners** — Internal owners, shipped features, recent UXR studies.
3. **jtbd_segments** — Jobs-to-be-done decomposition by creator segment (pro / aspiring / casual).
4. **measurement** — Engagement metrics, retention, creator satisfaction. What's the leading indicator?
5. **distribution_network** — Distribution and network effects. How does value compound for creators on this product?
6. **user_research** — UXR studies, creator interviews, surveys. What pain points creators report, what tools they want, what they hack around.

---

## integrity

Trust, safety, policy, harm.

1. **industry_regulatory** — Industry / regulatory landscape (EU DSA, state laws, platform peers).
2. **internal_owners** — Internal owners, shipped policies, active enforcement programs.
3. **threat_taxonomy** — Adversary models, harm vectors, attack surface decomposition.
4. **measurement** — Prevalence, false positive/negative tradeoffs, time-to-detect metrics.
5. **adjacent** — Privacy, security, legal precedent that intersects with the claim.
6. **user_research** — UXR / survey data on user-reported harms, perceived prevalence, what users want from enforcement.

---

## infra

Platform, systems, tooling, internal infra.

1. **industry_oss** — Industry / open-source landscape and benchmarks.
2. **internal_owners** — Internal owners, active systems, in-flight migrations.
3. **architectural_framing** — Boundaries, contracts, failure modes, scaling characteristics.
4. **performance_cost** — Benchmarks, scaling limits, hardware/cost tradeoffs.
5. **developer_experience** — Adoption, friction, alternatives, migration cost.
6. **user_research** — Engineer interviews / dev surveys on what they actually hack around, perceived friction, what they want the platform to do differently. (For infra, "users" are engineers — overlaps with developer_experience; consider dropping one in confirmation.)

---

## commerce

Monetization, marketplace, payments.

1. **industry_competitive** — Industry / competitive landscape (Amazon, Shopify, Stripe, etc.).
2. **internal_owners** — Internal owners, shipped products, pipeline.
3. **two_sided_dynamics** — Buyer/seller dynamics, supply/demand balance.
4. **unit_economics** — Unit economics, LTV, take rate, contribution margin.
5. **regulatory_payments** — Regulatory, payments rails, trust and chargeback dynamics.
6. **user_research** — Buyer/seller interviews, surveys, JTBD research. Where does the funnel actually break, what's the perceived friction.

---

## other (generic fallback)

When `domain` is `other` or unrecognized.

1. **industry_competitive** — External landscape, competitors, public benchmarks.
2. **internal_owners** — Who owns this internally, what's been shipped, what's in flight.
3. **problem_framing** — Decomposition, taxonomy, root causes.
4. **measurement** — How would we know if the claim is true / false?
5. **adjacent** — Adjacent domains the PM might be missing.
6. **user_research** — UXR / interviews / surveys with the relevant user segment. What's the actual JTBD, what pain points exist, what users actually do (vs. what we assume).

---

## Adding a new preset

1. Append a section keyed by the domain slug (lowercase, no spaces).
2. Provide 4–5 angles per the schema above.
3. PR back or open an issue.
