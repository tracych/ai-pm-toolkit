#!/usr/bin/env bash
# Smoke test for problem-statement-doctor plugin structure.
# Exits 0 with "PASS" on success, 1 with "FAIL: <reason>" otherwise.

set -u

# Resolve plugin root regardless of where the script is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR"

SKILL_FILE="$PLUGIN_DIR/skills/problem-statement-doctor/SKILL.md"
CMD_FILE="$PLUGIN_DIR/commands/problem-statement-doctor.md"
RUBRIC_FILE="$PLUGIN_DIR/assets/rubric.md"

fail() {
  echo "FAIL: $1"
  exit 1
}

# 1. SKILL.md exists.
[ -f "$SKILL_FILE" ] || fail "SKILL.md not found at $SKILL_FILE"

# 2. SKILL.md starts with --- frontmatter.
first_line="$(head -n 1 "$SKILL_FILE")"
[ "$first_line" = "---" ] || fail "SKILL.md does not start with '---' frontmatter"

# 3. SKILL.md frontmatter contains name: and description:.
# Extract everything between the first two '---' lines.
frontmatter="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$SKILL_FILE")"
echo "$frontmatter" | grep -q "^name:" || fail "SKILL.md frontmatter missing 'name:'"
echo "$frontmatter" | grep -q "^description:" || fail "SKILL.md frontmatter missing 'description:'"

# 4. Command file exists.
[ -f "$CMD_FILE" ] || fail "command file not found at $CMD_FILE"

# 5. Command file has frontmatter with description:.
cmd_first_line="$(head -n 1 "$CMD_FILE")"
[ "$cmd_first_line" = "---" ] || fail "command file does not start with '---' frontmatter"
cmd_frontmatter="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$CMD_FILE")"
echo "$cmd_frontmatter" | grep -q "^description:" || fail "command frontmatter missing 'description:'"

# 6. Rubric file exists.
[ -f "$RUBRIC_FILE" ] || fail "rubric file not found at $RUBRIC_FILE"

# 7. Rubric has exactly 8 numbered items (lines starting with N.).
numbered_count="$(grep -c '^[0-9]\.' "$RUBRIC_FILE" || true)"
[ "$numbered_count" -eq 8 ] || fail "rubric.md must have exactly 8 numbered items, found $numbered_count"

echo "PASS"
exit 0
