#!/usr/bin/env bash
# Smoke test for the idea-killer plugin.
# Validates structure, frontmatter, and asset shape.
# Prints PASS (exit 0) on success, FAIL: <reason> (exit 1) on failure.

set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"

fail() {
  echo "FAIL: $1"
  exit 1
}

SKILL="$ROOT/skills/idea-killer/SKILL.md"
CMD="$ROOT/commands/idea-killer.md"
ASSET="$ROOT/assets/failure_modes.md"

# 1. SKILL.md exists
[ -f "$SKILL" ] || fail "missing SKILL.md at $SKILL"

# Frontmatter: must start with --- and contain name: and description:
head -n 1 "$SKILL" | grep -q '^---$' || fail "SKILL.md missing opening --- frontmatter delimiter"
grep -q '^name:' "$SKILL" || fail "SKILL.md frontmatter missing 'name:'"
grep -q '^description:' "$SKILL" || fail "SKILL.md frontmatter missing 'description:'"

# 2. Command file exists with frontmatter
[ -f "$CMD" ] || fail "missing command file at $CMD"
head -n 1 "$CMD" | grep -q '^---$' || fail "command file missing opening --- frontmatter delimiter"
grep -q '^description:' "$CMD" || fail "command file frontmatter missing 'description:'"

# 3. assets/failure_modes.md exists and has exactly 7 ## headings
[ -f "$ASSET" ] || fail "missing asset at $ASSET"
H2_COUNT=$(grep -c '^## ' "$ASSET" || true)
if [ "$H2_COUNT" -ne 7 ]; then
  fail "failure_modes.md must have exactly 7 '## ' category headings, found $H2_COUNT"
fi

echo "PASS"
exit 0
