# Model vs Rules Matrix — Dimensions

Five dimensions. Score each cell of the 5×3 matrix 1–5 using the anchors below. Always tie the score to a concrete property of *this specific feature* — not a generic statement about models vs rules.

1. **Cost-at-scale** — What does serving the feature cost per request, multiplied by the expected request volume, over a one-year horizon?
   - 1: Unit cost dominates the team's infra budget; per-request cost grows roughly linearly with traffic with no cheap path.
   - 3: Cost is meaningful but bounded; budget conversations are quarterly, not weekly. Some traffic can take a cheap path.
   - 5: Negligible per-request cost (sub-millicent) or a fixed-cost authoring effort that doesn't grow with traffic.

2. **p95-latency** — Can this approach reliably meet the latency budget the feature implies (real-time UI, async batch, overnight, etc.) at the 95th-percentile request?
   - 1: p95 routinely violates the feature's latency budget; users see lag or the call must be moved off the critical path.
   - 3: p95 is within budget under normal load but degrades under spikes; some requests need fallback paths.
   - 5: p95 is comfortably under the latency budget with margin to spare, even under burst conditions.

3. **Explainability** — When the feature produces output X, can a non-engineer (PM, support agent, regulator, affected user) get a faithful, useful explanation of *why* X?
   - 1: Opaque — the best available explanation is a post-hoc rationalization that may or may not reflect the real cause.
   - 3: Partial — you can explain the broad shape (which input features mattered, which rule branch fired) but not the precise reason for borderline cases.
   - 5: Fully traceable — you can point to the exact input, rule, threshold, or signal that produced the output, in language a non-engineer can repeat.

4. **Maintainability** — Over a 12–18 month horizon, what does it take to keep this feature accurate as the world (inputs, user behavior, taxonomy, policy) changes?
   - 1: Every meaningful change requires retraining, prompt-engineering rounds, or hand-authoring a sprawling rule set that already strains the team.
   - 3: Tractable but demanding — owner needs a regular cadence (monthly evals, quarterly rule reviews, dataset refreshes) to keep quality from drifting.
   - 5: Cheap to maintain — most changes are configuration edits or small rule/data additions; the system tolerates input drift gracefully.

5. **Failure-recovery** — When the feature gets it wrong (and it will), how quickly and cleanly can the team detect, contain, and reverse the bad output?
   - 1: Failures are hard to detect (silent), hard to reproduce, and hard to roll back; bad outputs persist or compound in user-facing state.
   - 3: Failures are detectable via monitoring but recovery requires engineering work (model rollback, rule patch + redeploy, manual cleanup).
   - 5: Failures are loud (clear signals or hard-stops), bounded (rules guardrails or human-in-the-loop catches them), and reversible without engineering involvement.
