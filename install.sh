#!/usr/bin/env bash
# Install the skills for Claude Code, Codex and opencode.
#
#   ./install.sh                 symlink into ~/.claude/skills and ~/.agents/skills
#   ./install.sh --copy          copy instead of symlink
#   ./install.sh --project DIR   install into DIR/.claude/skills and DIR/.agents/skills
#   ./install.sh --only claude   one tool family: claude | agents (Codex + opencode)
#   ./install.sh --uninstall     remove what this script installed
#   ./install.sh --force         replace an existing skill of the same name
#
# Discovery paths:
#   Claude Code  ~/.claude/skills/<name>/SKILL.md
#   Codex        ~/.agents/skills/<name>/SKILL.md
#   opencode     ~/.agents/skills, ~/.claude/skills, ~/.config/opencode/skills
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src_dir="$repo_dir/skills"
mode=link
base="$HOME"
only=all
uninstall=false
force=false

usage() { sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

while (($#)); do
  case "$1" in
    --copy) mode=copy ;;
    --project) [[ $# -ge 2 ]] || usage 2; base="$(cd "$2" && pwd)"; shift ;;
    --only) [[ $# -ge 2 ]] || usage 2; only="$2"; shift ;;
    --uninstall) uninstall=true ;;
    --force) force=true ;;
    -h|--help) usage 0 ;;
    *) echo "unknown option: $1" >&2; usage 2 ;;
  esac
  shift
done

case "$only" in
  all) targets=("$base/.claude/skills" "$base/.agents/skills") ;;
  claude) targets=("$base/.claude/skills") ;;
  agents) targets=("$base/.agents/skills") ;;
  *) echo "--only must be claude or agents" >&2; exit 2 ;;
esac

# A skill dir is "ours" if it links into this repo or carries our marker file.
is_ours() {
  local dest="$1"
  if [[ -L "$dest" ]]; then
    [[ "$(readlink -f "$dest")" == "$src_dir/"* ]]
  else
    [[ -f "$dest/.ambition-skills" ]]
  fi
}

install_one() {
  local src="$1" dest="$2"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if is_ours "$dest"; then
      rm -rf "$dest"
    elif $force; then
      echo "  replacing existing $dest"
      rm -rf "$dest"
    else
      echo "  skip $dest (exists, not ours; use --force)"
      return 0
    fi
  fi
  if [[ "$mode" == link ]]; then
    ln -s "$src" "$dest"
  else
    cp -R "$src" "$dest"
    printf 'installed by %s\n' "$repo_dir" > "$dest/.ambition-skills"
  fi
  echo "  $mode $dest"
}

for target in "${targets[@]}"; do
  echo "$target"
  $uninstall || mkdir -p "$target"
  for src in "$src_dir"/*/; do
    src="${src%/}"
    dest="$target/$(basename "$src")"
    if $uninstall; then
      if [[ -e "$dest" || -L "$dest" ]] && is_ours "$dest"; then
        rm -rf "$dest"
        echo "  removed $dest"
      fi
    else
      install_one "$src" "$dest"
    fi
  done
done
