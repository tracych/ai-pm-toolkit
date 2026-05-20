#!/usr/bin/env bash
# Smoke test for cost-latency-budgeter plugin structure.
# Exits 0 with "PASS" on success, 1 with "FAIL: <reason>" otherwise.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR"

SKILL_FILE="$PLUGIN_DIR/skills/cost-latency-budgeter/SKILL.md"
CMD_FILE="$PLUGIN_DIR/commands/cost-latency-budgeter.md"
HTML_FILE="$PLUGIN_DIR/assets/budget_template.html"
TIERS_FILE="$PLUGIN_DIR/assets/model_tiers.md"
EXAMPLE_FILE="$PLUGIN_DIR/assets/examples/example-output.md"

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
frontmatter="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$SKILL_FILE")"
echo "$frontmatter" | grep -q "^name:" || fail "SKILL.md frontmatter missing 'name:'"
echo "$frontmatter" | grep -q "^description:" || fail "SKILL.md frontmatter missing 'description:'"

# 4. Command file exists with frontmatter and description:.
[ -f "$CMD_FILE" ] || fail "command file not found at $CMD_FILE"
cmd_first_line="$(head -n 1 "$CMD_FILE")"
[ "$cmd_first_line" = "---" ] || fail "command file does not start with '---' frontmatter"
cmd_frontmatter="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$CMD_FILE")"
echo "$cmd_frontmatter" | grep -q "^description:" || fail "command frontmatter missing 'description:'"

# 5. HTML template exists.
[ -f "$HTML_FILE" ] || fail "budget_template.html not found at $HTML_FILE"

# 6. HTML contains required markers.
grep -q "<html" "$HTML_FILE" || fail "budget_template.html missing '<html' tag"
grep -q "DAU" "$HTML_FILE" || fail "budget_template.html missing 'DAU' string"
grep -qi "tier" "$HTML_FILE" || fail "budget_template.html missing 'tier' string"
grep -q "cache" "$HTML_FILE" || fail "budget_template.html missing 'cache' string"
grep -q "localStorage" "$HTML_FILE" || fail "budget_template.html missing 'localStorage' string"

# 7. Model tiers reference exists.
[ -f "$TIERS_FILE" ] || fail "model_tiers.md not found at $TIERS_FILE"

# 8. Example output exists.
[ -f "$EXAMPLE_FILE" ] || fail "examples/example-output.md not found at $EXAMPLE_FILE"

echo "PASS"
exit 0
