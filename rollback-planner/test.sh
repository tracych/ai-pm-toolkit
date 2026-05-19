#!/usr/bin/env bash
# Validates rollback-planner tool structure.
# Run from repo root: bash rollback-planner/test.sh
set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"

fail() { echo "FAIL: $1"; exit 1; }

# 1. SKILL.md
SKILL="$ROOT/skills/rollback-planner/SKILL.md"
[ -f "$SKILL" ] || fail "missing $SKILL"
head -1 "$SKILL" | grep -q '^---$' || fail "SKILL.md missing opening --- frontmatter"
grep -q '^name:' "$SKILL" || fail "SKILL.md frontmatter missing name:"
grep -q '^description:' "$SKILL" || fail "SKILL.md frontmatter missing description:"

# 2. Command file
CMD="$ROOT/commands/rollback-planner.md"
[ -f "$CMD" ] || fail "missing $CMD"
head -1 "$CMD" | grep -q '^---$' || fail "command missing opening --- frontmatter"
grep -q '^description:' "$CMD" || fail "command frontmatter missing description:"

# 3. intake_questions.md — exactly 8 numbered items
INTAKE="$ROOT/assets/intake_questions.md"
[ -f "$INTAKE" ] || fail "missing $INTAKE"
COUNT=$(grep -cE '^[0-9]+\. ' "$INTAKE")
[ "$COUNT" = "8" ] || fail "intake_questions.md must have exactly 8 numbered items (found $COUNT)"

# 4. comms_templates.md — exactly 3 templates (## headings)
COMMS="$ROOT/assets/comms_templates.md"
[ -f "$COMMS" ] || fail "missing $COMMS"
HCOUNT=$(grep -cE '^## ' "$COMMS")
[ "$HCOUNT" = "3" ] || fail "comms_templates.md must have exactly 3 '## ' headings (found $HCOUNT)"

# 5. checklist_template.html
HTML="$ROOT/assets/checklist_template.html"
[ -f "$HTML" ] || fail "missing $HTML"
grep -q '<html' "$HTML" || fail "checklist_template.html missing <html"
grep -q 'localStorage' "$HTML" || fail "checklist_template.html missing literal 'localStorage'"
grep -q 'rollback' "$HTML" || fail "checklist_template.html missing literal 'rollback'"

echo "PASS"
exit 0
