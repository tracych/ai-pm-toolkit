# meeting-summary — eval seed (v0.1)

5 rows. Every assertion in `example-assertions.md` is exercised by at least one row (see "Tests assertions" column).

| # | Input (short) | Expected behavior | Pass/fail criteria | Tests assertions |
|---|---------------|-------------------|--------------------|------------------|
| 1 | **Happy path:** 250-word transcript with 3 named attendees (Anya, Brent, Carlos), 2 action items with named owners, 1 decision. | Produce exactly 3 bullets; each ≤ 20 words; action items tagged with the correct owners; no invented names. | Bullet count = 3. All proper nouns in output appear in input. Each action-item bullet has `(owner: <name>)`. Each bullet word count ≤ 20. | #1, #2, #3, #5 |
| 2 | **Refusal — short input:** 60-word transcript, well-formed but under the threshold. | Refuse with exact string. | Output exactly equals: `I need a longer transcript to summarize.` (string equality, including trailing punctuation, no extra whitespace). | #6 |
| 3 | **Boundary — exactly at threshold:** 100-word transcript with 2 attendees and 1 action item. | Summarize, do not refuse. (Threshold is strictly `< 100`.) | Output is NOT the refusal string. Bullet count = 3. | #1, #6 |
| 4 | **Adversarial — tempts invention:** 200-word transcript with no attendee names ("Speaker 1", "Speaker 2"), but the meeting agenda mentions "who should attend the launch review?" | Summarize without inventing names; if owner unknown, use `(owner: unassigned)`. | No proper nouns in output that aren't in input. Any action-item bullet uses `(owner: unassigned)`. No speculation about who "should" have attended. | #2, #3, #4 |
| 5 | **Format stress + non-transcript:** Single sentence input: `"Reviewed the deck and approved."` (under 100 words AND not transcript-shaped). | Refuse with the not-a-transcript string (more specific than the length-refusal). When two refusals could fire, prefer the more specific. | Output exactly equals: `This doesn't look like a meeting transcript. Paste the transcript text and I'll summarize it.` | #7 |

---

**Coverage check:**

- #1 (3 bullets exact) — rows 1, 3
- #2 (no invented names) — rows 1, 4
- #3 (owner tags) — rows 1, 4
- #4 (no speculation) — row 4
- #5 (≤ 20 words per bullet, 1 sentence) — row 1
- #6 (refusal: < 100 words) — rows 2, 3 (3 is the negative case — refusal must NOT fire at exactly 100)
- #7 (refusal: not a transcript) — row 5

All 7 assertions covered. Row 5 also surfaces a refusal-precedence question the PRD doesn't answer (which refusal wins when both triggers fire?) — flag this in `summary.md` as a PRD gap for v0.2.

**Next step:** hand this seed to `/eval-set-curator` to expand to 50 rows with more boundary, adversarial, and multi-language coverage.
