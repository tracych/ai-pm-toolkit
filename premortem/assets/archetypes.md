# Failure archetypes

Five canonical ways launches die. Always cover all five, in this order. Each story must be grounded in the specific launch brief — generic platitudes are a failure mode of this skill itself.

---

## adoption-flop

**Definition.** The launch shipped on time, didn't break anything, didn't upset anyone — and almost no one used it. Users either never discovered the surface, bounced off the first interaction, or tried it once and never returned. The feature exists but is invisible in the metrics that matter.

**Prompting questions:**
- Where does the user first encounter this feature, and what competes for that attention slot?
- What is the smallest unit of value the user gets on first use, and how many seconds does it take to feel it?
- What does the activation funnel look like — impression → click → first meaningful action → repeat?

---

## trust-incident

**Definition.** The feature did something a user found surprising, embarrassing, or violating — even if it was technically working as designed. Wrong recipient, wrong context, exposed data, misleading copy, an automated action the user didn't realize they'd authorized. A small number of incidents become screenshots, the screenshots become a story, the story becomes a brand problem.

**Prompting questions:**
- What's the worst single piece of content / action / disclosure this feature could surface to the wrong person?
- Where is the user implicitly trusting that the system knows their intent — and what happens if it's wrong?
- Which user segments have the highest cost of a mistake (regulated industries, public figures, minors, sensitive communities)?

---

## abuse-vector

**Definition.** Bad actors found a use case the team never designed for: spam amplification, harassment delivery, evasion of an existing safety system, fraud, scraping, automated extraction. The feature itself works fine — it's just being used as a weapon. Often invisible until a third party (press, regulator, researcher) surfaces it.

**Prompting questions:**
- If this feature were free, anonymous, and infinitely scalable, what's the most profitable wrong thing someone could do with it?
- Does it create a new way to contact, target, or affect users who haven't opted in?
- Does it weaken any existing rate-limit, identity, or safety check — or create a path that bypasses one?

---

## performance-regression

**Definition.** The feature shipped and worked, but the surface around it got worse: page load times crept up, an existing engagement metric softened, error rates rose on adjacent flows, infrastructure cost outpaced the value created. The launch wins its own scorecard while quietly losing the broader one.

**Prompting questions:**
- What shared surface, query path, or backend dependency does this feature add load to?
- Which existing top-line metric on the same surface is most likely to be cannibalized or distracted?
- What's the per-action cost (compute, storage, third-party API) and how does it scale with success?

---

## internal-politics

**Definition.** The launch died from inside. A partner team blocked it, leadership priorities shifted, a sibling launch got the resource it needed, a review process flagged it late, or the org reorged out from under it. The feature was sound; the path to keeping it shipped was not. Often the earliest signal is a quiet drop in cross-functional responsiveness.

**Prompting questions:**
- Which team has veto power (legal, policy, security, infra, a partner PM) and what's their current stated priority?
- What sibling launch is competing for the same review slot, the same surface, or the same headcount?
- Who at the director-or-above level has publicly tied themselves to this launch, and how stable is that sponsorship over the next two quarters?
