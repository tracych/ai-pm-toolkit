# Open Questions & Lower-Confidence Items

Synthetic example. For documentation purposes.

---

## Messaging-correlated retention is causal, not just correlational

- **Status:** Internal UXR shows correlation. No A/B evidence.
- **Caveat:** Engaged users may message more for unrelated reasons (engagement begets engagement).
- **Next step:** Design an A/B exposing first-7-day cohort to a messaging entry-point. ~3 weeks to design, 6 weeks to read out.

## Backend rewrite estimate (4 quarters)

- **Status:** Code validator flagged 2-quarter estimate as wrong; cited messaging-infra rewrite needed for any integration with content surface.
- **Caveat:** Estimate based on single eng's read of the dependency graph, not formal scoping.
- **Next step:** Formal scoping with messaging-infra TL. 1-week effort.

## Integration patterns that worked at peers

- **Status:** App A and App B succeeded with "tight integration." Specifics unknown.
- **Caveat:** What "tight integration" means varies — could be DM-from-post, content-share-via-DM, or notification-driven re-engagement.
- **Next step:** Direct PM-to-PM conversations via warm intros. ~30-min conversation each.

## Onboarding-flow optimization opportunity size

- **Status:** Two peer datapoints suggest comparable lift. Not validated for SimpleApp specifically.
- **Caveat:** Onboarding flow at SimpleApp is already 2-screen — may have less room for optimization than the peer cases.
- **Next step:** Funnel analysis on current onboarding. 2-day audit by data scientist.
