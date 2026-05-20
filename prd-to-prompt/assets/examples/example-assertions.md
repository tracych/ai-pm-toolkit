# meeting-summary — testable assertions (v0.1)

Each assertion is lifted 1-to-1 from a CONSTRAINT or REFUSAL POLICY item in `example-prompt.md`. Each is exercised by at least one row in `example-eval-seed.md`.

Legend: `[CONSTRAINT]` = behavioral rule. `[REFUSAL]` = trigger-and-response rule. `[FORMAT]` = output-shape rule.

---

1. **[FORMAT]** Output contains exactly 3 top-level markdown bullets.
   - How to check: count lines matching `^- ` in the output; must equal 3.
   - Source PRD phrase: "summarize the meeting in 3 bullets" / prompt constraint "MUST produce exactly 3 top-level bullets".

2. **[CONSTRAINT]** No attendee name appears in the output that is not present verbatim in the input transcript.
   - How to check: extract proper nouns from output bullets; for each, assert it appears as a substring in the input transcript.
   - Source PRD phrase: "never invent attendees" / prompt constraint "MUST NOT include any attendee name that does not appear verbatim".

3. **[CONSTRAINT]** Action items in bullets carry an owner tag: `(owner: <name>)` or `(owner: unassigned)`.
   - How to check: for each bullet that mentions an action verb (will, owns, completes, by <date>), regex-match `\(owner: [^\)]+\)`.
   - Source PRD phrase: "attribute each action item to the named owner".

4. **[CONSTRAINT]** Output contains no speculation about decisions, outcomes, or sentiments not present in the transcript.
   - How to check: human-judged for v0.1 (LLM-as-judge in v0.2+). Flag any output containing affect words ("felt", "confident", "agreed enthusiastically") not grounded in transcript quotes.
   - Source PRD phrase: "never invent" (extended to outcomes/sentiments, not just attendees).

5. **[FORMAT]** Each bullet is one sentence of 20 words or fewer (owner tag included in budget).
   - How to check: split output on `\n- `; for each bullet, word-count ≤ 20 and sentence-count = 1.

6. **[REFUSAL]** If input word count < 100, output is exactly: `I need a longer transcript to summarize.`
   - How to check: word-count input; if < 100, string-equality check on full output.
   - Source PRD phrase: "refuse if the transcript is < 100 words".

7. **[REFUSAL]** If input is clearly not a transcript (single sentence, URL, code), output is exactly: `This doesn't look like a meeting transcript. Paste the transcript text and I'll summarize it.`
   - How to check: heuristic on input (no speaker labels, no turn-taking); if heuristic fires, string-equality check on output.

---

**Total: 7 assertions (4 CONSTRAINT, 2 REFUSAL, 2 FORMAT, with #1 and #5 both counting as FORMAT and #1 also implied by the "3 bullets" PRD phrase).**

No `[UNTESTABLE]` assertions in v0.1. If "speculation about sentiments" (#4) proves hard to LLM-judge reliably in profiling, downgrade to `[UNTESTABLE]` and resolve in v0.2 by tightening the PRD with explicit forbidden affect-words.
