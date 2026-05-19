#!/usr/bin/env bash
# retro-facilitator/test.sh — structural validation, no network, no deps.
set -u

ROOT="$(cd "$(dirname "$0")" && pwd)"

fail() {
  echo "FAIL: $1"
  exit 1
}

SKILL="$ROOT/skills/retro-facilitator/SKILL.md"
CMD="$ROOT/commands/retro-facilitator.md"
AGENDA="$ROOT/assets/agenda.md"
TEMPLATE="$ROOT/assets/archive_template.html"

# --- SKILL.md ---
[ -f "$SKILL" ] || fail "SKILL.md missing at $SKILL"

# Frontmatter: must start with --- and contain a closing --- with name: and description: between.
first_line="$(head -n 1 "$SKILL")"
[ "$first_line" = "---" ] || fail "SKILL.md must start with --- frontmatter"

# Extract frontmatter block (lines 2 until next --- line).
fm="$(awk 'NR==1 && $0=="---"{infm=1; next} infm && $0=="---"{exit} infm{print}' "$SKILL")"
echo "$fm" | grep -q '^name:' || fail "SKILL.md frontmatter missing name:"
echo "$fm" | grep -q '^description:' || fail "SKILL.md frontmatter missing description:"

# --- command file ---
[ -f "$CMD" ] || fail "command file missing at $CMD"
cmd_first="$(head -n 1 "$CMD")"
[ "$cmd_first" = "---" ] || fail "command file must start with --- frontmatter"
cmd_fm="$(awk 'NR==1 && $0=="---"{infm=1; next} infm && $0=="---"{exit} infm{print}' "$CMD")"
echo "$cmd_fm" | grep -q '^description:' || fail "command frontmatter missing description:"

# --- agenda.md ---
[ -f "$AGENDA" ] || fail "agenda.md missing at $AGENDA"
numbered_count="$(grep -cE '^[[:space:]]*[1-9][0-9]*\.' "$AGENDA" || true)"
[ "$numbered_count" = "5" ] || fail "agenda.md must have exactly 5 numbered items (found $numbered_count)"

# --- archive_template.html ---
[ -f "$TEMPLATE" ] || fail "archive_template.html missing at $TEMPLATE"
grep -q '<html' "$TEMPLATE" || fail "archive_template.html must contain <html"
grep -q '<table id="retros">' "$TEMPLATE" || fail "archive_template.html must contain <table id=\"retros\">"

echo "PASS"
exit 0
