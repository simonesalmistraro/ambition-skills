#!/usr/bin/env bash
# Validate the skills and exercise install.sh in a throwaway HOME.
set -uo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fails=0
pass() { echo "ok   $1"; }
fail() { echo "FAIL $1"; fails=$((fails + 1)); }
check() { local name="$1"; shift; if "$@"; then pass "$name"; else fail "$name"; fi; }

frontmatter() { awk 'NR==1 && $0=="---" {f=1; next} f && $0=="---" {exit} f' "$1"; }

# Description = the description: line plus its indented continuation lines.
description_of() {
  frontmatter "$1" | awk '/^description:/ {sub(/^description:[ ]*/, ""); d=$0; f=1; next}
    f && /^[ ]+/ {sub(/^[ ]+/, ""); d=d " " $0; next} f {exit} END {print d}'
}

echo "== skill format (Agent Skills spec: name, description)"
for skill_md in "$repo_dir"/skills/*/SKILL.md; do
  dir="$(basename "$(dirname "$skill_md")")"
  name="$(frontmatter "$skill_md" | sed -n 's/^name:[ ]*//p')"
  desc="$(description_of "$skill_md")"
  check "$dir: has frontmatter" test -n "$(frontmatter "$skill_md")"
  check "$dir: name matches dir" test "$name" = "$dir"
  check "$dir: name is lowercase-hyphen, <=64" \
    bash -c '[[ "$1" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ && ${#1} -le 64 ]]' _ "$name"
  check "$dir: description 1-1024 chars" \
    bash -c '(( ${#1} >= 1 && ${#1} <= 1024 ))' _ "$desc"
done

echo "== content hygiene"
check "no em/en dashes" bash -c '! grep -rnP "[\x{2013}\x{2014}]" "$1"/skills' _ "$repo_dir"
check "no home paths" bash -c '! grep -rnE "/home/|/Users/|C:\\\\Users|~/" "$1"/skills' _ "$repo_dir"
check "no email addresses" \
  bash -c '! grep -rnE "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[a-z]{2,}" "$1"/skills' _ "$repo_dir"

echo "== install.sh"
sandbox="$repo_dir/.test-tmp"
rm -rf "$sandbox"; mkdir -p "$sandbox/home/.claude/skills/deepen"
echo "user's own skill" > "$sandbox/home/.claude/skills/deepen/SKILL.md"
run() { HOME="$sandbox/home" "$repo_dir/install.sh" "$@" > "$sandbox/out" 2>&1; }

run
check "links into ~/.agents/skills" test -L "$sandbox/home/.agents/skills/assumption-check"
check "links into ~/.claude/skills" test -L "$sandbox/home/.claude/skills/red-team-crew"
check "leaves a foreign skill alone" grep -q "user's own skill" "$sandbox/home/.claude/skills/deepen/SKILL.md"
run
check "re-run is idempotent" test -L "$sandbox/home/.agents/skills/deepen"
run --force
check "--force replaces a foreign skill" test -L "$sandbox/home/.claude/skills/deepen"
run --uninstall
check "--uninstall removes links" bash -c '! ls "$1"/home/.agents/skills/* >/dev/null 2>&1' _ "$sandbox"
mkdir -p "$sandbox/proj"
run --project "$sandbox/proj" --copy --only agents
check "--project --copy installs files" test -f "$sandbox/proj/.agents/skills/deepen/SKILL.md"
check "--only agents skips claude" test ! -e "$sandbox/proj/.claude"
run --project "$sandbox/proj" --uninstall
check "--uninstall removes copies" test ! -e "$sandbox/proj/.agents/skills/deepen"
rm -rf "$sandbox"

echo
if ((fails)); then echo "$fails check(s) failed"; exit 1; fi
echo "all checks passed"
