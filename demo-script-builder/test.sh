#!/usr/bin/env bash
# Self-check for demo-script-builder. Prints PASS / FAIL: <reason>.

set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"

fail() {
  echo "FAIL: $1"
  exit 1
}

SKILL="$ROOT/skills/demo-script-builder/SKILL.md"
CMD="$ROOT/commands/demo-script-builder.md"
PROFILES="$ROOT/assets/audience_profiles.md"

# SKILL.md exists with frontmatter containing name: and description:
[ -f "$SKILL" ] || fail "missing $SKILL"
head -n 1 "$SKILL" | grep -q '^---$' || fail "SKILL.md missing opening --- frontmatter"
awk '/^---$/{c++; next} c==1{print}' "$SKILL" | grep -q '^name:' || fail "SKILL.md frontmatter missing name:"
awk '/^---$/{c++; next} c==1{print}' "$SKILL" | grep -q '^description:' || fail "SKILL.md frontmatter missing description:"

# Command file has description, argument-hint, and audience labels in argument-hint
[ -f "$CMD" ] || fail "missing $CMD"
head -n 1 "$CMD" | grep -q '^---$' || fail "command file missing opening --- frontmatter"
CMD_FM="$(awk '/^---$/{c++; next} c==1{print}' "$CMD")"
echo "$CMD_FM" | grep -q '^description:' || fail "command frontmatter missing description:"
echo "$CMD_FM" | grep -q '^argument-hint:' || fail "command frontmatter missing argument-hint:"
HINT_LINE="$(echo "$CMD_FM" | grep '^argument-hint:')"
echo "$HINT_LINE" | grep -q 'exec'     || fail "argument-hint does not mention 'exec'"
echo "$HINT_LINE" | grep -q 'customer' || fail "argument-hint does not mention 'customer'"
echo "$HINT_LINE" | grep -q 'engineer' || fail "argument-hint does not mention 'engineer'"

# audience_profiles.md exists and has 3 audience sections (case-insensitive)
[ -f "$PROFILES" ] || fail "missing $PROFILES"
grep -qiE '^## exec'     "$PROFILES" || fail "audience_profiles.md missing '## exec' section"
grep -qiE '^## customer' "$PROFILES" || fail "audience_profiles.md missing '## customer' section"
grep -qiE '^## engineer' "$PROFILES" || fail "audience_profiles.md missing '## engineer' section"

echo "PASS"
exit 0
