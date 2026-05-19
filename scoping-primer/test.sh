#!/usr/bin/env bash
# Smoke test for scoping-primer plugin structure.
# Validates SKILL.md, command, and assets file conform to expected shape.

set -u

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

SKILL="$ROOT_DIR/skills/scoping-primer/SKILL.md"
COMMAND="$ROOT_DIR/commands/scoping-primer.md"
ASSETS="$ROOT_DIR/assets/engineer_questions.md"

fail() {
  echo "FAIL: $1"
  exit 1
}

# 1. SKILL.md exists, has frontmatter with name + description
[ -f "$SKILL" ] || fail "SKILL.md not found at $SKILL"

# Frontmatter must start with --- on line 1
head -n 1 "$SKILL" | grep -q '^---$' || fail "SKILL.md missing opening --- frontmatter"

# Extract frontmatter block (between first two --- lines)
FRONTMATTER=$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$SKILL")

echo "$FRONTMATTER" | grep -qE '^name:[[:space:]]*[^[:space:]]' \
  || fail "SKILL.md frontmatter missing 'name:' field"

echo "$FRONTMATTER" | grep -qE '^description:' \
  || fail "SKILL.md frontmatter missing 'description:' field"

# 2. Command file exists with description frontmatter
[ -f "$COMMAND" ] || fail "Command file not found at $COMMAND"

head -n 1 "$COMMAND" | grep -q '^---$' || fail "Command file missing opening --- frontmatter"

CMD_FRONTMATTER=$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$COMMAND")

echo "$CMD_FRONTMATTER" | grep -qE '^description:' \
  || fail "Command file frontmatter missing 'description:' field"

# 3. Assets file exists with exactly 12 numbered items
[ -f "$ASSETS" ] || fail "Assets file not found at $ASSETS"

NUM_COUNT=$(grep -cE '^[0-9]+\.' "$ASSETS" || true)
[ "$NUM_COUNT" -eq 12 ] || fail "Expected 12 numbered items in engineer_questions.md, found $NUM_COUNT"

# Verify items 1 through 12 each appear at start of a line
for i in $(seq 1 12); do
  grep -qE "^${i}\." "$ASSETS" || fail "engineer_questions.md missing item ${i}."
done

echo "PASS"
exit 0
