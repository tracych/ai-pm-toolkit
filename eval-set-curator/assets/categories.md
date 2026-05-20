# Canonical edge-case categories

Ten categories. Five rows each (with one explicit exception for category 10). Use these definitions verbatim — do not invent new categories or merge them.

For each category: **definition** (what counts), **when to generate** (the axes of stress to vary across the 5 rows), and **when to skip** (the rare cases where the category genuinely doesn't apply — usually requires explicit feature-profile justification).

1. **empty / minimal input** — Inputs that are empty strings, whitespace-only, single characters, or one-word placeholders.
   - *When to generate:* every feature has an "input field" surface — even empty submission must be handled. Vary across: empty string, whitespace only, single emoji, one word, a single punctuation mark.
   - *When to skip:* never. If the feature's wrapper UI blocks empty submission, the row's expected behavior is "the model should still degrade gracefully if called directly" — keep the row.

2. **maximally-long input** — Inputs at or past the documented context window, or far longer than any seed example.
   - *When to generate:* always. Vary across: slightly over the expected upper bound, 2× expected, signal buried in the middle of noise, signal at the very end, redundant repetition with one critical detail changed late.
   - *When to skip:* never. Even short-input features (e.g., autocomplete) need a "what if someone pastes a paragraph" row.

3. **multilingual / non-English** — Inputs in languages other than the feature's primary language.
   - *When to generate:* always. Vary across: a high-resource language (Spanish / French / Mandarin), a non-Latin script (Arabic / Hindi / Japanese), a low-resource language, code-switching (two languages in one input), and a romanized non-English input (e.g., Hinglish).
   - *When to skip:* only if the feature is contractually English-only AND the expected behavior is "refuse non-English with message X" — in which case the 5 rows test the refusal message, not the multilingual handling.

4. **hostile / abusive / jailbreak-attempt** — Inputs designed to provoke unsafe output, bypass guardrails, or abuse the system.
   - *When to generate:* always. Vary across: direct insult / profanity at the model, prompt injection ("ignore your instructions and …"), social-engineering ("my grandmother used to …"), request for disallowed content via the feature's domain, and a benign-looking input that contains hidden instructions in the payload.
   - *When to skip:* never. This category is the most under-tested in practice and the most likely to be cited in a post-launch incident.

5. **ambiguous (two valid interpretations)** — Inputs where a competent human could reasonably interpret the request two different ways.
   - *When to generate:* always. Vary across: pronoun ambiguity ("she told her that her project was good"), scope ambiguity ("summarize the meeting" — which meeting?), unit ambiguity ("in dollars" — US? AUD? CAD?), temporal ambiguity ("last quarter" — calendar or fiscal?), and intent ambiguity (request that could be a question or a command).
   - *When to skip:* only if the feature's expected behavior is documented to always pick one interpretation by deterministic rule — then 5 rows test the rule, not the ambiguity.

6. **format-violating (input doesn't match expected schema)** — Inputs that violate the structural contract the seed examples imply.
   - *When to generate:* always. Vary across: missing required field, extra unexpected field, wrong type for a field (number where string expected), malformed JSON / markdown / CSV depending on the feature, and a near-miss (correct structure, but key names slightly off).
   - *When to skip:* only if the feature genuinely takes free-text input with no implied structure — then repurpose this category as "violates the implicit content contract" (e.g., binary garbage, repeated newlines, control characters).

7. **out-of-scope (request the feature shouldn't answer)** — Inputs that are well-formed and benign but ask the feature to do something outside its purpose.
   - *When to generate:* always. Vary across: a request from an adjacent domain (similar but not the feature's job), a generic "tell me about X" request, a meta-request about the model itself, a request that would require external action (sending email, making a purchase), and a request that requires up-to-the-minute information.
   - *When to skip:* never. The expected behavior is usually "decline and redirect", and the pass criterion is whether the decline message is correct.

8. **edge-of-domain (technically in-scope but rare)** — Inputs that fit the feature's domain but represent the long tail of legitimate use.
   - *When to generate:* always. Vary across the long tail of the seed pattern: an unusually-formatted-but-valid input, an input from a rare user segment, an input that exercises a rarely-triggered feature path, an input with all-default values, and an input at the extreme of one dimension (longest valid title, smallest valid amount).
   - *When to skip:* only if the seed examples already cover the full distribution — but the skill should default to assuming they don't.

9. **implicit assumption (input relies on context the model doesn't have)** — Inputs that would make sense to a colleague but the model has no way to resolve.
   - *When to generate:* always. Vary across: refers to a person by first name only with no context, refers to "the project" / "the document" / "the last one", uses a company-internal acronym or codename, assumes the model knows the user's role or team, and references a previous conversation turn that wasn't passed in.
   - *When to skip:* only if the feature explicitly receives full context (e.g., a long retrieval-augmented payload that always contains the referent).

10. **regression-from-prior-bug** — Inputs that have failed this feature (or a closely related one) before, in production, in QA, or in a prior eval run.
    - *When to generate:* only when the user provides at least 1 known failure. Generate one row per provided bug, up to 5. If fewer than 5 bugs are provided, you may add at most 1 close variant per bug to fill out the category — but never more than 2 variants per bug, and never fabricate bugs the user didn't provide.
    - *When to skip:* always skip if the user provides 0 known bugs. Leave the category empty (0 rows) and flag it prominently in the markdown summary. Fabricating regression rows is worse than having none — it gives false confidence that known issues are tested.
