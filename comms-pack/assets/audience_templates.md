# Audience templates

Six templates, in this exact order. Each section is one audience. Tone and length differ deliberately — if two artifacts read the same, the pack has failed.

## release-notes

**File:** `release-notes.md`
**Format:** markdown, 3 sections
**Length:** 100-200 words total
**Voice:** neutral, product-led, third-person. No marketing puffery. No exclamation marks.

**Structure (exact — render the H2 headings shown below as real `##` headings in the output file; they're escaped here so the template document keeps a clean structure):**

```
# <Feature name> — <Date or version>

\## What

<2-3 sentences. Concrete. What exists now that didn't before. Name the surface (web / desktop / mobile) and who it's for.>

\## Why it matters

<2-3 sentences. The problem this solves, in plain language. One concrete user pain it removes. No hype words.>

\## Get started

<2-4 lines. Steps or settings location to start using it. Link placeholder if relevant: `<link to docs>`. End with "Questions? <support channel placeholder>".>
```

**Watch-outs:**
- No internal codenames in user-facing copy.
- "Get started" should be actionable in under 30 seconds of reading.
- If the feature is opt-in, say so in "Get started" — surprise defaults erode trust.

---

## internal

**File:** `internal.md`
**Format:** markdown, exactly 5 bullets
**Length:** under 150 words
**Voice:** warm, specific, internal. Use real first names where the brief provides them. Celebrate the team without overclaiming.

**Structure (exact):**

```markdown
# <Feature name> shipped — <Date>

- **What shipped:** <one sentence, plain.>
- **Who built it:** <names / team. If brief doesn't say, write `<team>` and ask the PM to fill.>
- **Who to thank:** <names of XFN partners — design, eng, support, legal, data — whoever stretched. If brief doesn't say, write `<XFN partners>` placeholder.>
- **What's next:** <one sentence on the immediate next milestone or rollout step.>
- **Feedback:** <where to send it — channel, doc, form. Placeholder if not in brief.>
```

**Watch-outs:**
- Internal tolerates rougher edges than external. Don't over-polish.
- Naming people you don't know is worse than leaving placeholders.

---

## exec-update

**File:** `exec-update.md`
**Format:** markdown, exactly 5 bullets + 1 "Ask" line
**Length:** under 120 words
**Voice:** terse, business-impact only. No implementation detail. No team thank-yous. Numbers where defensible; `[NEEDS EVIDENCE: ...]` where not.

**Structure (exact):**

```markdown
# <Feature name> — exec update

- **Shipped:** <what, to whom, when. One line.>
- **Why it matters (business):** <revenue / retention / risk / efficiency — pick the one that's true.>
- **Early signal:** <metric or qualitative signal from beta / pilot. Flag if speculative.>
- **Risk:** <the one thing that could still go wrong.>
- **Next decision point:** <what triggers the next exec-level check-in.>

**Ask:** <one specific ask — air cover, budget, headcount, decision needed by date. Or "None — informational." Never invent an ask.>
```

**Watch-outs:**
- Execs read the first 2 bullets. Front-load impact.
- "Ask" must be specific and answerable. "Support" is not an ask. "Approve $40k for Q3 expansion" is.
- Every numeric claim must trace to the brief. Otherwise → `[NEEDS EVIDENCE: ...]`.

---

## customer-email

**File:** `customer-email.md`
**Format:** markdown, with `Subject:` line then body
**Length:** 3 short paragraphs + 1 CTA
**Voice:** friendly, direct, second-person ("you"). No corporate-speak ("we are pleased to announce"). No emojis unless the brand explicitly uses them.

**Structure (exact):**

```markdown
Subject: <under 50 chars. Specific benefit, not feature name.>

Hi <first name>,

<Paragraph 1: the problem you've heard from them, named in their words. 2-3 sentences max.>

<Paragraph 2: what's new and what it does for them — second-person, concrete. 2-3 sentences max.>

<Paragraph 3: what to do next, when it's available, who to contact for help. 1-2 sentences.>

<CTA — one line, action verb first. e.g. "Turn on autosave →" with a `<link>` placeholder.>

— <Sender name / team>
```

**Watch-outs:**
- Subject line ≠ feature name. Lead with the benefit.
- One CTA. Not three. If you want two, the email is two emails.
- Every claim about user outcome must trace to the brief, or → `[NEEDS EVIDENCE: ...]`.

---

## social

**File:** `social.md`
**Format:** single block of text (no markdown headers)
**Length:** ≤280 characters total, including the CTA and any link placeholder
**Voice:** punchy, conversational. No corporate-speak. At most 2 hashtags. Link placeholder counts toward 280.

**Structure (exact, no headers — just one block):**

```
<Hook: 1 short sentence that earns attention. Question, contrast, or sharp claim.>

<Value: 1 short sentence on what's new and who it's for.>

<CTA: action verb + link placeholder.> <#optional> <#hashtag>
```

**Watch-outs:**
- If it goes over 280, cut the hook before cutting the CTA.
- No "We're excited to announce". Earn the attention or skip the post.
- The link placeholder (e.g. `<link>`) counts toward 280. Budget ~25 chars for it.

---

## faq

**File:** `faq.md`
**Format:** markdown, 8 Q&A pairs total
**Length:** answers 1-3 sentences each
**Voice:** matter-of-fact. Answer the question asked, don't pivot to marketing.

**Structure (exact):**

```markdown
# <Feature name> — FAQ

### Common questions

**Q: When does it ship / when can I get it?**
A: <date or rollout phase. Specific.>

**Q: Who gets it?**
A: <which segment / plan / surface.>

**Q: How do I turn it on?**
A: <setting location or default-on note.>

**Q: What does it cost?**
A: <price, plan tier, or "included" — be explicit.>

### Sharp-edge questions

**Q: What's the catch?**
A: <honest constraint or limitation. Don't dodge.>

**Q: What breaks or changes about my current workflow?**
A: <migration / behavior change call-out, or "nothing" if true.>

**Q: How does this compare to <obvious alternative>?**
A: <one honest sentence on tradeoff. Don't trash competitors.>

**Q: What if I don't want it?**
A: <opt-out path, or "it's opt-in" — never gaslight the user.>
```

**Watch-outs:**
- Sharp-edge answers are where trust is built. Don't dodge — partial honesty is worse than admitting a gap.
- If the brief doesn't tell you the answer, write `<TBD: ask PM>` rather than inventing.
