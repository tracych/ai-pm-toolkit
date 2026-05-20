#!/usr/bin/env bash
# Smoke test for eval-set-curator plugin structure.
# Exits 0 with "PASS" on success, 1 with "FAIL: <reason>" otherwise.

set -u

# Resolve plugin root regardless of where the script is invoked from.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR"

SKILL_FILE="$PLUGIN_DIR/skills/eval-set-curator/SKILL.md"
CMD_FILE="$PLUGIN_DIR/commands/eval-set-curator.md"
CAT_FILE="$PLUGIN_DIR/assets/categories.md"
VIEWER_FILE="$PLUGIN_DIR/assets/viewer_template.html"
EX_JSONL="$PLUGIN_DIR/assets/examples/example-eval-set.jsonl"
EX_MD="$PLUGIN_DIR/assets/examples/example-eval-set.md"

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

# 6. Categories file exists.
[ -f "$CAT_FILE" ] || fail "categories file not found at $CAT_FILE"

# 7. Categories has exactly 10 numbered items (lines starting with N. where N is 1-10).
numbered_count="$(grep -c '^[0-9]\+\.' "$CAT_FILE" || true)"
[ "$numbered_count" -eq 10 ] || fail "categories.md must have exactly 10 numbered items, found $numbered_count"

# 8. Viewer template exists and looks like HTML with localStorage.
[ -f "$VIEWER_FILE" ] || fail "viewer template not found at $VIEWER_FILE"
grep -q "<html" "$VIEWER_FILE" || fail "viewer template missing <html"
grep -q "localStorage" "$VIEWER_FILE" || fail "viewer template missing localStorage usage"

# 9. Example JSONL exists and has exactly 50 lines.
[ -f "$EX_JSONL" ] || fail "example JSONL not found at $EX_JSONL"
line_count="$(wc -l < "$EX_JSONL" | tr -d ' ')"
[ "$line_count" -eq 50 ] || fail "example JSONL must have exactly 50 lines, found $line_count"

# 10. Example markdown exists.
[ -f "$EX_MD" ] || fail "example markdown not found at $EX_MD"

echo "PASS"
exit 0
