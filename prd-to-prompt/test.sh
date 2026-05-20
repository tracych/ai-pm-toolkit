#!/usr/bin/env bash
# Smoke test for prd-to-prompt plugin structure.
# Exits 0 with "PASS" on success, 1 with "FAIL: <reason>" otherwise.

set -u

# Resolve plugin root regardless of where the script is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR"

SKILL_FILE="$PLUGIN_DIR/skills/prd-to-prompt/SKILL.md"
CMD_FILE="$PLUGIN_DIR/commands/prd-to-prompt.md"
SKELETON_FILE="$PLUGIN_DIR/assets/prompt-skeleton.md"
EX_PROMPT="$PLUGIN_DIR/assets/examples/example-prompt.md"
EX_ASSERT="$PLUGIN_DIR/assets/examples/example-assertions.md"
EX_EVAL="$PLUGIN_DIR/assets/examples/example-eval-seed.md"

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
skill_fm="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$SKILL_FILE")"
echo "$skill_fm" | grep -q "^name:" || fail "SKILL.md frontmatter missing 'name:'"
echo "$skill_fm" | grep -q "^description:" || fail "SKILL.md frontmatter missing 'description:'"

# 4. Command file exists.
[ -f "$CMD_FILE" ] || fail "command file not found at $CMD_FILE"

# 5. Command file has frontmatter with description:.
cmd_first_line="$(head -n 1 "$CMD_FILE")"
[ "$cmd_first_line" = "---" ] || fail "command file does not start with '---' frontmatter"
cmd_fm="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$CMD_FILE")"
echo "$cmd_fm" | grep -q "^description:" || fail "command frontmatter missing 'description:'"

# 6. Prompt skeleton exists.
[ -f "$SKELETON_FILE" ] || fail "prompt-skeleton.md not found at $SKELETON_FILE"

# 7. Prompt skeleton contains all 6 required section headers.
for section in "ROLE" "CAPABILITIES" "CONSTRAINTS" "REFUSAL POLICY" "OUTPUT FORMAT" "EXAMPLES"; do
  grep -q "^## $section\$" "$SKELETON_FILE" || fail "prompt-skeleton.md missing '## $section' header"
done

# 8. Worked examples all exist.
[ -f "$EX_PROMPT" ] || fail "example-prompt.md not found at $EX_PROMPT"
[ -f "$EX_ASSERT" ] || fail "example-assertions.md not found at $EX_ASSERT"
[ -f "$EX_EVAL" ] || fail "example-eval-seed.md not found at $EX_EVAL"

echo "PASS"
exit 0
