#!/usr/bin/env bash
# Smoke-test the assumption-tracker structure. Run from the repo root:
#   bash assumption-tracker/test.sh
set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILL="$ROOT/skills/assumption-tracker/SKILL.md"
CMD="$ROOT/commands/assumption-tracker.md"
TPL="$ROOT/assets/template.html"

fail() { echo "FAIL: $1"; exit 1; }

# SKILL.md
[ -f "$SKILL" ] || fail "missing $SKILL"
head -n 1 "$SKILL" | grep -q '^---$' || fail "SKILL.md missing opening --- frontmatter"
awk '/^---$/{c++} c==2{exit} {print}' "$SKILL" | grep -q '^name:' || fail "SKILL.md frontmatter missing name:"
awk '/^---$/{c++} c==2{exit} {print}' "$SKILL" | grep -q '^description:' || fail "SKILL.md frontmatter missing description:"

# command file
[ -f "$CMD" ] || fail "missing $CMD"
head -n 1 "$CMD" | grep -q '^---$' || fail "command missing opening --- frontmatter"
awk '/^---$/{c++} c==2{exit} {print}' "$CMD" | grep -q '^description:' || fail "command frontmatter missing description:"

# template.html
[ -f "$TPL" ] || fail "missing $TPL"
grep -q '<html' "$TPL" || fail "template.html missing <html"
grep -q 'loadBearing' "$TPL" || fail "template.html missing literal 'loadBearing'"
grep -q 'testable' "$TPL" || fail "template.html missing literal 'testable'"
grep -q 'assumptions' "$TPL" || fail "template.html missing literal 'assumptions'"

echo "PASS"
exit 0
