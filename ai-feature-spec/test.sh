#!/usr/bin/env bash
# Smoke test for ai-feature-spec plugin structure.
# Exits 0 with "PASS" on success, 1 with "FAIL: <reason>" otherwise.

set -u

# Resolve plugin root regardless of where the script is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR"

SKILL_FILE="$PLUGIN_DIR/skills/ai-feature-spec/SKILL.md"
CMD_FILE="$PLUGIN_DIR/commands/ai-feature-spec.md"
TEMPLATE_FILE="$PLUGIN_DIR/assets/spec-template.md"
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
skill_frontmatter="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$SKILL_FILE")"
echo "$skill_frontmatter" | grep -q "^name:" || fail "SKILL.md frontmatter missing 'name:'"
echo "$skill_frontmatter" | grep -q "^description:" || fail "SKILL.md frontmatter missing 'description:'"

# 4. Command file exists.
[ -f "$CMD_FILE" ] || fail "command file not found at $CMD_FILE"

# 5. Command file has frontmatter with description:.
cmd_first_line="$(head -n 1 "$CMD_FILE")"
[ "$cmd_first_line" = "---" ] || fail "command file does not start with '---' frontmatter"
cmd_frontmatter="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$CMD_FILE")"
echo "$cmd_frontmatter" | grep -q "^description:" || fail "command frontmatter missing 'description:'"

# 6. Spec template file exists.
[ -f "$TEMPLATE_FILE" ] || fail "spec template not found at $TEMPLATE_FILE"

# 7. Spec template contains exactly 9 section headers (lines starting with '## ').
section_count="$(grep -c '^## ' "$TEMPLATE_FILE" || true)"
[ "$section_count" -eq 9 ] || fail "spec-template.md must have exactly 9 '## ' section headers, found $section_count"

# 8. Spec template contains each of the 9 expected numbered headers.
for n in 1 2 3 4 5 6 7 8 9; do
  grep -q "^## ${n}\." "$TEMPLATE_FILE" || fail "spec-template.md missing section header '## ${n}.'"
done

# 9. Example output file exists.
[ -f "$EXAMPLE_FILE" ] || fail "example output not found at $EXAMPLE_FILE"

echo "PASS"
exit 0
