#!/usr/bin/env bash
# Smoke test for demo-to-product-gap-auditor plugin structure.
# Exits 0 with "PASS" on success, 1 with "FAIL: <reason>" otherwise.

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR"

SKILL_FILE="$PLUGIN_DIR/skills/demo-to-product-gap-auditor/SKILL.md"
CMD_FILE="$PLUGIN_DIR/commands/demo-to-product-gap-auditor.md"
DIMS_FILE="$PLUGIN_DIR/assets/audit-dimensions.md"
TPL_FILE="$PLUGIN_DIR/assets/audit_template.html"
EX_MD="$PLUGIN_DIR/assets/examples/example-output.md"
EX_HTML="$PLUGIN_DIR/assets/examples/example-audit.html"

fail() {
  echo "FAIL: $1"
  exit 1
}

# 1. SKILL.md exists and has frontmatter with name + description.
[ -f "$SKILL_FILE" ] || fail "SKILL.md not found at $SKILL_FILE"
first_line="$(head -n 1 "$SKILL_FILE")"
[ "$first_line" = "---" ] || fail "SKILL.md does not start with '---' frontmatter"
frontmatter="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$SKILL_FILE")"
echo "$frontmatter" | grep -q "^name:" || fail "SKILL.md frontmatter missing 'name:'"
echo "$frontmatter" | grep -q "^description:" || fail "SKILL.md frontmatter missing 'description:'"

# 2. Command file exists and has frontmatter with description.
[ -f "$CMD_FILE" ] || fail "command file not found at $CMD_FILE"
cmd_first_line="$(head -n 1 "$CMD_FILE")"
[ "$cmd_first_line" = "---" ] || fail "command file does not start with '---' frontmatter"
cmd_frontmatter="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$CMD_FILE")"
echo "$cmd_frontmatter" | grep -q "^description:" || fail "command frontmatter missing 'description:'"

# 3. audit-dimensions.md exists with exactly 10 numbered items.
[ -f "$DIMS_FILE" ] || fail "audit-dimensions.md not found at $DIMS_FILE"
numbered_count="$(grep -c '^[0-9]\{1,2\}\.[[:space:]]' "$DIMS_FILE" || true)"
[ "$numbered_count" -eq 10 ] || fail "audit-dimensions.md must have exactly 10 numbered items, found $numbered_count"

# 4. audit_template.html exists and contains <html and localStorage.
[ -f "$TPL_FILE" ] || fail "audit_template.html not found at $TPL_FILE"
grep -q "<html" "$TPL_FILE" || fail "audit_template.html missing '<html' tag"
grep -q "localStorage" "$TPL_FILE" || fail "audit_template.html missing 'localStorage'"

# 5. Example files exist.
[ -f "$EX_MD" ] || fail "examples/example-output.md not found at $EX_MD"
[ -f "$EX_HTML" ] || fail "examples/example-audit.html not found at $EX_HTML"

echo "PASS"
exit 0
