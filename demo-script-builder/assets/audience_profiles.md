# Audience profiles

Opinionated framing rules and common objection types for each of the three supported demo audiences. The skill loads exactly one section per run. Do not add a fourth.

---

## exec

**Lens:** business impact. Frame everything as cost saved, revenue moved, risk reduced, or strategic optionality created. Time is the scarcest resource in the room.

### Framing rules

1. **Lead with the number.** Open the hook with a dollar figure, a percent, a count, or a risk dimension — not the feature name.
2. **Five bullets, not five paragraphs.** The walkthrough beats should be parseable as a five-bullet narrative arc, each beat ending on impact ("...which cuts cycle time from 3 days to 4 hours").
3. **Connect to a strategic priority.** Reference an existing company goal, OKR theme, or board-level metric the exec already cares about. Don't introduce a new metric mid-demo.
4. **Compare to the alternative.** Make the do-nothing or do-the-obvious-thing cost explicit. Execs decide on relative bets.
5. **Close with the ask, not the recap.** Decision, budget, headcount, air cover — name it.

### Common objection types to pre-rebut

1. **ROI / payback.** "What's the actual return, on what timeline, and what's the confidence interval?" — give a range, name the dominant assumption, say what would invalidate it.
2. **Opportunity cost.** "Why this instead of the three other bets we could make with the same team?" — name the alternatives, explain the comparative leverage.
3. **Risk surface.** "What blows up if this goes wrong — regulatory, brand, customer trust, internal politics?" — name the top risk, name the mitigation, name the threshold at which you'd roll back.

---

## customer

**Lens:** value and outcome. Frame everything as the job they're trying to do, the time saved, or the frustration removed. They don't care how it works; they care that it works for them.

### Framing rules

1. **Benefit before feature.** Every beat opens with what they get, not what we built. "You can now ship a campaign in one click" before "we added a one-click publish endpoint".
2. **Use their language.** Mirror the customer's actual vocabulary for their workflow — never internal product or engineering jargon.
3. **Show their workflow, not ours.** Stage directions should walk through *their* typical task path, in their order, not the order the product was built in.
4. **Anchor on a moment of pain.** The setup should reference the frustrating before-state they'll recognize immediately ("today this takes you 40 minutes and three browser tabs").
5. **End on what they can do tomorrow.** Close with the concrete next action they can take in their own workflow — not a roadmap or a future feature.

### Common objection types to pre-rebut

1. **Migration / switching cost.** "Great, but I already have a workflow. What does it cost me to change?" — name the realistic switching cost, name what stays the same, name the parallel-run option.
2. **Reliability / trust.** "What happens when this breaks during my busy period?" — name the failure modes, the recovery path, and the support commitment.
3. **Edge case for their specific situation.** "My setup is unusual because of X — does this work for me?" — acknowledge the variant, say honestly whether it's covered today, name when it would be if not.

---

## engineer

**Lens:** mechanism. Frame everything as architecture, data flow, interfaces, and the honest edge cases. Engineers will sniff out hand-waving instantly and discount everything that follows.

### Framing rules

1. **Show the seams.** Stage directions should expose where components meet — API boundaries, data flow, the schema, the queue. Don't hide the mechanism behind the UI.
2. **Be concrete about the edge cases.** Name the three nastiest cases (concurrency, partial failure, schema migration, etc.) and how the design handles them — or admits it doesn't yet.
3. **Honest about tradeoffs.** Every design choice has a cost; name it. "We picked eventual consistency here, which means X is possible — we accept that because Y."
4. **Real numbers, not adjectives.** "p99 latency under 80ms at 10k QPS" beats "it's fast." If you don't have numbers yet, say so.
5. **Make the wow moment a mechanism, not a UI flourish.** Engineers wow at clever architecture, simplification, or a constraint elegantly resolved — not at animations.

### Common objection types to pre-rebut

1. **Failure modes / correctness.** "What happens under partial failure, network partition, or a poison-pill input?" — name the failure model, the detection path, the recovery, and the data-loss bound.
2. **Scale / performance ceiling.** "Where does this design break — at what QPS, dataset size, or fan-out does it stop working?" — name the bottleneck, the headroom, the next architectural step when it's reached.
3. **Maintenance / ownership cost.** "Who owns this in 18 months, and what's the operational burden — runbooks, oncall, schema evolution?" — name the owning team, the runbook status, and the deprecation/evolution story honestly.
