#!/usr/bin/env bash
# Self-test for hypothesis-canvas. Run from the repo root:
#   bash hypothesis-canvas/test.sh
set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILL="$ROOT/skills/hypothesis-canvas/SKILL.md"
CMD="$ROOT/commands/hypothesis-canvas.md"
HTML="$ROOT/assets/canvas_template.html"

fail() { echo "FAIL: $1"; exit 1; }

# SKILL.md
[ -f "$SKILL" ] || fail "missing $SKILL"
head -n 1 "$SKILL" | grep -q '^---$' || fail "SKILL.md missing opening --- frontmatter"
awk '/^---$/{c++} c==2{exit} {print}' "$SKILL" | grep -q '^name:' || fail "SKILL.md frontmatter missing name:"
awk '/^---$/{c++} c==2{exit} {print}' "$SKILL" | grep -q '^description:' || fail "SKILL.md frontmatter missing description:"

# command file
[ -f "$CMD" ] || fail "missing $CMD"
head -n 1 "$CMD" | grep -q '^---$' || fail "command file missing opening --- frontmatter"
awk '/^---$/{c++} c==2{exit} {print}' "$CMD" | grep -q '^description:' || fail "command frontmatter missing description:"

# canvas template
[ -f "$HTML" ] || fail "missing $HTML"
grep -qi '<html' "$HTML" || fail "canvas_template.html missing <html"

for f in change metric magnitude segment mechanism abandon-if; do
  grep -q "$f" "$HTML" || fail "canvas_template.html missing field: $f"
done

grep -q 'abandon-banner' "$HTML" || fail "canvas_template.html missing #abandon-banner element"

echo "PASS"
exit 0
