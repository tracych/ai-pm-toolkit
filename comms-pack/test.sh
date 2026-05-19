#!/usr/bin/env bash
# Structural tests for comms-pack. Run from repo root: bash comms-pack/test.sh
set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"

fail() {
  echo "FAIL: $1"
  exit 1
}

# 1. SKILL.md exists with frontmatter containing name: and description:
SKILL="$ROOT/skills/comms-pack/SKILL.md"
[ -f "$SKILL" ] || fail "missing $SKILL"
head -n 1 "$SKILL" | grep -q '^---$' || fail "SKILL.md missing opening --- frontmatter"
# Confirm closing --- exists within first 30 lines
head -n 30 "$SKILL" | tail -n +2 | grep -q '^---$' || fail "SKILL.md missing closing --- frontmatter"
head -n 30 "$SKILL" | grep -q '^name:' || fail "SKILL.md frontmatter missing name:"
head -n 30 "$SKILL" | grep -q '^description:' || fail "SKILL.md frontmatter missing description:"

# 2. Command file has frontmatter with description:
CMD="$ROOT/commands/comms-pack.md"
[ -f "$CMD" ] || fail "missing $CMD"
head -n 1 "$CMD" | grep -q '^---$' || fail "command file missing opening --- frontmatter"
head -n 10 "$CMD" | grep -q '^description:' || fail "command file frontmatter missing description:"

# 3. audience_templates.md exists and has exactly 6 H2 sections
TPL="$ROOT/assets/audience_templates.md"
[ -f "$TPL" ] || fail "missing $TPL"
H2_COUNT="$(grep -c '^## ' "$TPL")"
[ "$H2_COUNT" -eq 6 ] || fail "audience_templates.md must have exactly 6 '## ' headings, found $H2_COUNT"

# 4. preview_template.html exists, contains <html, contains all 6 audience names
PREVIEW="$ROOT/assets/preview_template.html"
[ -f "$PREVIEW" ] || fail "missing $PREVIEW"
grep -q '<html' "$PREVIEW" || fail "preview_template.html missing <html"
for name in release-notes internal exec-update customer-email social faq; do
  grep -q "$name" "$PREVIEW" || fail "preview_template.html missing audience name: $name"
done

echo "PASS"
exit 0
