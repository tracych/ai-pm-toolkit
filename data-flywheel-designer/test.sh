#!/usr/bin/env bash
# Smoke test for data-flywheel-designer plugin structure.
# Exits 0 with "PASS" on success, 1 with "FAIL: <reason>" otherwise.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR"

SKILL_FILE="$PLUGIN_DIR/skills/data-flywheel-designer/SKILL.md"
CMD_FILE="$PLUGIN_DIR/commands/data-flywheel-designer.md"
STAGES_FILE="$PLUGIN_DIR/assets/flywheel-stages.md"
HTML_TEMPLATE="$PLUGIN_DIR/assets/flywheel_diagram_template.html"
EXAMPLE_MD="$PLUGIN_DIR/assets/examples/example-output.md"
EXAMPLE_HTML="$PLUGIN_DIR/assets/examples/example-flywheel.html"

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

# 4. Command file exists.
[ -f "$CMD_FILE" ] || fail "command file not found at $CMD_FILE"

# 5. Command file has frontmatter with description:.
cmd_first_line="$(head -n 1 "$CMD_FILE")"
[ "$cmd_first_line" = "---" ] || fail "command file does not start with '---' frontmatter"
cmd_frontmatter="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$CMD_FILE")"
echo "$cmd_frontmatter" | grep -q "^description:" || fail "command frontmatter missing 'description:'"

# 6. flywheel-stages.md exists.
[ -f "$STAGES_FILE" ] || fail "flywheel-stages.md not found at $STAGES_FILE"

# 7. flywheel-stages.md has exactly 6 numbered items (lines starting with N.).
numbered_count="$(grep -c '^[0-9]\.' "$STAGES_FILE" || true)"
[ "$numbered_count" -eq 6 ] || fail "flywheel-stages.md must have exactly 6 numbered items, found $numbered_count"

# 8. HTML template exists.
[ -f "$HTML_TEMPLATE" ] || fail "flywheel_diagram_template.html not found at $HTML_TEMPLATE"

# 9. HTML template contains <html.
grep -q "<html" "$HTML_TEMPLATE" || fail "flywheel_diagram_template.html missing '<html' tag"

# 10. HTML template contains all 6 stage names.
for stage in "Cold-start data plan" "Signal capture" "Labeling pipeline" "Storage" "Retraining trigger" "Closing the loop"; do
  grep -q "$stage" "$HTML_TEMPLATE" || fail "flywheel_diagram_template.html missing stage name: $stage"
done

# 11. HTML template contains localStorage.
grep -q "localStorage" "$HTML_TEMPLATE" || fail "flywheel_diagram_template.html missing 'localStorage'"

# 12. Example markdown exists.
[ -f "$EXAMPLE_MD" ] || fail "example-output.md not found at $EXAMPLE_MD"

# 13. Example HTML exists.
[ -f "$EXAMPLE_HTML" ] || fail "example-flywheel.html not found at $EXAMPLE_HTML"

echo "PASS"
exit 0
