#!/usr/bin/env bash
# Scarica tutte le skill da github.com/ohgvez/skills-claude e le installa
# in ~/.claude/skills (o nella cartella passata come primo argomento).
#
#   curl -fsSL https://raw.githubusercontent.com/ohgvez/skills-claude/main/install.sh | bash
#   ./install.sh [cartella-destinazione]
#
# Variabili opzionali: REPO (default ohgvez/skills-claude), BRANCH (default main),
# FORCE=1 per sovrascrivere skill già installate.
set -euo pipefail

REPO="${REPO:-ohgvez/skills-claude}"
BRANCH="${BRANCH:-main}"
DEST="${1:-$HOME/.claude/skills}"
FORCE="${FORCE:-0}"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# Se lo script è lanciato dentro una copia locale del repo, usa quella.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "$script_dir" ] && [ -f "$script_dir/install.sh" ] && [ -d "$script_dir/.git" ]; then
  src="$script_dir"
  echo "Uso la copia locale: $src"
else
  echo "Scarico $REPO@$BRANCH ..."
  curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/heads/$BRANCH" | tar -xz -C "$tmp"
  src="$(find "$tmp" -mindepth 1 -maxdepth 1 -type d | head -n1)"
fi

mkdir -p "$DEST"
installed=0; skipped=0
declare -A seen=()

# Ordina per profondità: le skill in cima al repo hanno la precedenza sui
# duplicati annidati (es. emilkowalski-skills/skills/*, react-bits/AGENTS/SKILLS/*).
while IFS= read -r skill_md; do
  dir="$(dirname "$skill_md")"
  name="$(basename "$dir")"
  [ -n "${seen[$name]:-}" ] && continue
  seen[$name]=1
  target="$DEST/$name"
  if [ -e "$target" ] && [ "$FORCE" != "1" ]; then
    echo "  = $name (già presente, salto; usa FORCE=1 per sovrascrivere)"
    skipped=$((skipped + 1))
    continue
  fi
  rm -rf "$target"
  cp -R "$dir" "$target"
  echo "  + $name"
  installed=$((installed + 1))
done < <(find "$src" -name SKILL.md -not -path '*/.git/*' \
           | awk -F/ '{ print NF "\t" $0 }' | sort -n | cut -f2-)

echo
echo "Fatto: $installed skill installate, $skipped saltate -> $DEST"
