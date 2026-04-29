# Open Questions & Lower-Confidence Items

Synthetic example for documentation.

---

## LLM-judged labels production-viable at scale

- **Status:** Single offline experiment (E12345) showed 4% accuracy lift with LLM-judged labels. Production latency and throughput unproven.
- **Caveat:** Two peer-team post-mortems (P-123, P-456) flagged latency issues with similar approaches.
- **Next step:** Scope production-readiness review with infra team. ~1 week of eng time.

## Online vs offline lift gap

- **Status:** Offline lift 4–7%. Industry rule of thumb suggests 30–50% online degradation.
- **Caveat:** Quality Model X has historically shown smaller online degradation (~20%); the rule may not apply.
- **Next step:** Design online A/B for the strongest signal-augmentation variant. 2-week setup, 4-week readout.

## Whether the upstream signal pipeline is owned and maintained

- **Status:** Code search confirmed the pipeline exists; ownership unclear.
- **Caveat:** Two of three angle agents flagged ambiguous ownership in adjacent threads.
- **Next step:** Direct conversation with infra eng director. 30-min meeting.
