# Canonical engineering scoping questions

The 12 questions engineers reliably ask in feature scoping. Order matters — this is roughly the order they come up in a real meeting. Each has 2-3 sub-prompts to structure the PM's draft answer.

1. Data shape
   - What entities are involved, and what are the key fields and types?
   - What's the relationship between entities (1:1, 1:N, N:M)?
   - Is any field user-supplied free text vs. constrained / enumerated?

2. Scale
   - How many entities exist today, and what's the expected growth rate?
   - What's the peak QPS (or events/sec) we should design for?
   - Are there hot keys, fan-out, or skew concerns?

3. Latency budget
   - What are the p50 / p95 latency targets for the primary user action?
   - Is there a hard ceiling above which the feature is broken (e.g. user abandons)?
   - Does any part of the flow run async / offline, and what's its budget?

4. Failure modes
   - What happens on backend failure, network failure, or dependency timeout?
   - Do we degrade gracefully (cached / stale / read-only) or hard-fail with a message?
   - Is partial success possible, and how do we represent it to the user?

5. Auth / permissions
   - Who is authorized to perform each action — owner only, team, admin, anyone signed in?
   - Are there role-based or attribute-based access checks beyond simple ownership?
   - Any auditing, consent, or compliance requirements for the action?

6. Storage
   - Where does state live — existing table, new table, cache, blob store, third-party?
   - What's the retention policy — forever, N days, until user deletes?
   - Is the data PII / sensitive, and does that change storage/encryption requirements?

7. Migration
   - Is there existing data that needs to be backfilled or transformed?
   - What's the rollout shape — dark launch, gradual %, geo, cohort, feature flag?
   - Can old and new code paths coexist, and for how long?

8. Observability
   - What events / metrics do we instrument, and at what granularity?
   - What dashboards exist or need to be built — for product, for ops, for both?
   - What alerts page someone, and what's the runbook stub?

9. Rollback
   - Is there a kill switch / feature flag we can flip without a deploy?
   - Can we roll back partially (one cohort, one surface) or only globally?
   - If we roll back after data is written, what do we do with the partial state?

10. Dependencies
    - What upstream services / APIs do we depend on, and what's their SLO?
    - What downstream consumers might break if our schema or behavior changes?
    - Are any dependencies owned by other teams, and have we synced with them?

11. Edge cases
    - Empty state — first-time user, zero items, never-used feature: what do they see?
    - Max sizes — longest name, biggest list, most concurrent items: what breaks?
    - Concurrent updates — two clients editing the same thing: last-write-wins, merge, lock?

12. Success metric
    - What single signal proves this feature is working as intended?
    - What guardrail metrics tell us we broke something (latency, error rate, abandonment)?
    - How long until we expect to see signal — days, weeks, a full cycle?
