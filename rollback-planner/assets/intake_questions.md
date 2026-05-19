# Rollback intake — 8 mandatory questions

Walk these in order. For each: draft the best initial answer from context, show to the PM, ask "confirm, edit, or skip with placeholder?".

1. **Change description.** What exactly is launching? Scope — feature, surface, % rollout, geography, audience.
2. **Blast radius.** Who and what is affected if this goes wrong? Number of users (or %), which surfaces, which regions, which downstream systems.
3. **Kill-switch mechanism.** How do we turn this off? Be specific: config flag name, feature flag key, deploy revert command, infra toggle. "We'll figure it out" is not an answer.
4. **Owners.** Who is the DRI during the launch window? Who is the backup? Who owns comms? Use role placeholders only (`<launch-lead>`, `<oncall-engineer>`, `<comms-lead>`, `<exec-sponsor>`) — never real names.
5. **Dependencies.** What services, consumers, data flows, or partner integrations depend on this? Who needs to be notified before we flip the kill-switch?
6. **Metric thresholds (3 numeric triggers — rollback fires if ANY trips).** Each trigger must have a metric name, a numeric threshold with units, and a duration window.
   - **Error rate trigger** — e.g., `> 0.5% over 10m`
   - **Latency trigger** — e.g., `p95 > 800ms over 5m`
   - **Business metric trigger** — e.g., `checkout completion drops > 10% vs prior 7d baseline over 30m`
   - Vague answers ("if things go bad", "if errors spike") are rejected. Re-ask with a number.
7. **Comms surfaces.** Where do we post when the rollback fires, and in what order? Examples: status page → internal on-call channel → customer email → exec brief. List the surfaces in send-order.
8. **Dry-run cadence.** When do we rehearse the rollback in a non-prod environment before launch? At minimum, once. If the PM opts out of the dry-run, flag it as a risk in the plan but do not block.
