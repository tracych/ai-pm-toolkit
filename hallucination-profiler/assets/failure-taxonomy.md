# LLM Failure Mode Taxonomy

Twelve canonical failure modes for LLM-powered features. The profiler picks the top 7 ranked by severity × likelihood for the specific feature shape. For each: a definition, the typical detection strategy, and the typical user-facing mitigation. These are starting points — the per-feature profile must adapt detection and mitigation to the actual input/output shape.

Modes 1–4 and 10 are *hallucinations* (the model invents). Modes 5, 6, 8, 9, 11 are *failures* (the model refuses, drifts, or mis-formats). Mode 7 (prompt-injection-compliance) and mode 12 (harmful-content) are *abuse/safety* failures. All ship as bugs.

1. **Fabricated entities** — The model invents people, products, companies, files, APIs, URLs, or IDs that do not exist in the source context.
   - *Typical detection:* string-match every named entity in the output against the retrieved context or an allowlist; flag any entity that does not appear upstream.
   - *Typical mitigation:* inline-citation UI that links each entity back to its source, or post-generation rejection of outputs containing unknown entities.

2. **Fabricated citations** — The model produces a citation (link, paper title, case number, doc reference) that looks well-formed but points to nothing real or to the wrong target.
   - *Typical detection:* resolve every citation against the actual source corpus or a URL HEAD check; flag unresolvable or mismatched citations.
   - *Typical mitigation:* render citations as clickable verifications with source previews; never display unverified citations as plain text.

3. **Wrong-but-confident** — The model returns a factually incorrect answer in a confident tone, with no hedging, when the correct answer was retrievable.
   - *Typical detection:* LLM-as-judge against a ground-truth eval set, plus production sampling reviewed by SMEs; track agreement rate.
   - *Typical mitigation:* confidence indicators tied to retrieval coverage, plus a visible "AI-generated — verify before relying on this" pattern around the output.

4. **Stale knowledge** — The model returns an answer based on training-data world-state that has since changed (prices, org charts, API versions, policy text).
   - *Typical detection:* compare output entities against a freshness-checked source-of-truth; alert when output references entities older than a defined cutoff.
   - *Typical mitigation:* timestamp every output ("based on data as of <date>"); route time-sensitive queries through retrieval rather than parametric memory.

5. **Format violation** — The model returns output that does not match the required schema, structure, or surface contract (broken JSON, missing required field, wrong section order).
   - *Typical detection:* schema validator or parser on every output; counter for parse failures and field-missing errors.
   - *Typical mitigation:* validator with retry-with-correction loop; fall back to a deterministic template if validation fails twice.

6. **Unit and number errors** — The model gets the digits, units, currencies, dates, or arithmetic wrong even when source data was correct.
   - *Typical detection:* extract numeric claims from output and recompute against the source; flag mismatches above a tolerance.
   - *Typical mitigation:* render numbers from the source data deterministically (tool call / template), not from model text; show the source row inline.

7. **Prompt-injection compliance** — The model follows instructions embedded in user-controlled input (a document, an email, a web page) instead of treating them as data.
   - *Typical detection:* canary phrases in inputs that the model should never echo; spike detection on outputs that contain instruction-shaped strings from inputs.
   - *Typical mitigation:* input quarantining and clear system-prompt boundaries; allow-list of actions the model can take, regardless of what the input says.

8. **Refusal when shouldn't** — The model refuses, hedges, or returns an apologetic non-answer on a legitimate request, often due to over-tuned safety or vague policy.
   - *Typical detection:* classifier or regex over outputs for refusal patterns ("I can't help with that", "As an AI") on requests labeled in-scope; alert on rate spikes.
   - *Typical mitigation:* fallback UX that surfaces an alternative path (search, contact human, retry with rephrasing); track refusal rate as a product metric, not a safety win.

9. **Partial compliance** — The model addresses some of the request and silently drops the rest (asks for 5 items, gets 3; asks for two tasks, gets one).
   - *Typical detection:* parse the request structure and the output structure; flag arity or coverage mismatches.
   - *Typical mitigation:* explicit progress UI (e.g., "3 of 5 results returned — retry?") and an automatic continuation pass.

10. **Conflated sources** — The model merges information from two or more distinct source records into one false combined claim ("Customer A had Customer B's order issue").
    - *Typical detection:* per-claim source attribution check — for every factual span in the output, verify it can be traced to exactly one source record.
    - *Typical mitigation:* one-source-per-claim rendering with visible source labels; explicit separator UI when multiple sources are summarized.

11. **Scope drift** — The model answers a related but different question, expands beyond the requested scope, or adds unrequested recommendations.
    - *Typical detection:* LLM-as-judge comparing output sections to the explicit request scope; counter for "unrequested section" detections.
    - *Typical mitigation:* output-shape contract enforced server-side (only the requested fields rendered); show the user a "what was asked" summary above the answer.

12. **Harmful content** — The model produces output that is unsafe, biased, defamatory, or violates a policy specific to the deployment (regulated industry, child-facing surface, internal HR context).
    - *Typical detection:* classifier ensemble (toxicity, PII, policy-specific) on every output; sampled human review.
    - *Typical mitigation:* hard-block on classifier hit with a route to human escalation; never silently rewrite — always inform the user the response was withheld.
