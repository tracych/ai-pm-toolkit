#!/usr/bin/env bash
# Smoke test for the premortem plugin. No network, no deps.
set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
SKILL="$HERE/skills/premortem/SKILL.md"
CMD="$HERE/commands/premortem.md"
ARCH="$HERE/assets/archetypes.md"

fail() {
  echo "FAIL: $1"
  exit 1
}

# 1. SKILL.md exists and has YAML frontmatter with name + description
[ -f "$SKILL" ] || fail "missing $SKILL"
first_line="$(head -n 1 "$SKILL")"
[ "$first_line" = "---" ] || fail "SKILL.md missing opening --- frontmatter"
# Extract frontmatter block (lines between first --- and next ---)
fm="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$SKILL")"
echo "$fm" | grep -q '^name:' || fail "SKILL.md frontmatter missing name:"
echo "$fm" | grep -q '^description:' || fail "SKILL.md frontmatter missing description:"

# 2. Command file has frontmatter with description:
[ -f "$CMD" ] || fail "missing $CMD"
cmd_first="$(head -n 1 "$CMD")"
[ "$cmd_first" = "---" ] || fail "command file missing opening --- frontmatter"
cmd_fm="$(awk '/^---$/{c++; next} c==1{print} c==2{exit}' "$CMD")"
echo "$cmd_fm" | grep -q '^description:' || fail "command frontmatter missing description:"

# 3. archetypes.md exists and has exactly 5 '## ' headings
[ -f "$ARCH" ] || fail "missing $ARCH"
heading_count="$(grep -c '^## ' "$ARCH" || true)"
[ "$heading_count" = "5" ] || fail "archetypes.md should have exactly 5 '## ' headings, found $heading_count"

echo "PASS"
exit 0
