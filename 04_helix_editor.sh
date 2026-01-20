#!/usr/bin/env bash
set -euo pipefail

THEMES_URL="https://github.com/CptPotato/helix-themes/releases/download/latest/build.tar.gz"
THEMES_DIR="$HOME/.config/helix/themes"
HELIX_DIR="$HOME/.config/helix"

echo "[1/6] Installing system packages..."
sudo apt update
sudo apt install -y helix git curl ripgrep fd-find python3-pip nodejs npm tar

echo "[2/6] Installing Python tooling..."
sudo npm i -g pyright
python3 -m pip install --user -U ruff

echo "[3/6] Installing Helix themes pack into $THEMES_DIR ..."
mkdir -p "$THEMES_DIR"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

curl -LfsS "$THEMES_URL" -o "$tmp/build.tar.gz"
tar -xzf "$tmp/build.tar.gz" -C "$THEMES_DIR"

echo "[4/6] Writing Helix config..."
mkdir -p "$HELIX_DIR"

cat > "$HELIX_DIR/config.toml" <<'TOML'
theme = "gruvbox_original_dark_hard"

[editor]
line-number = "relative"
mouse = true
true-color = true
bufferline = "multiple"
auto-format = true
cursorline = true
rulers = [80, 100, 120]
text-width = 100
completion-trigger-len = 1
auto-save = true

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.indent-guides]
render = true

[editor.file-picker]
hidden = false

[editor.lsp]
display-messages = true
TOML

cat > "$HELIX_DIR/languages.toml" <<'TOML'
[[language]]
name = "python"
auto-format = true
formatter = { command = "ruff", args = ["format", "-"] }
TOML

echo "[5/6] Verifying binaries (note: ruff may not be on PATH if installed with --user)..."
echo "hx:      $(command -v hx || echo 'NOT FOUND')"
echo "pyright: $(command -v pyright || echo 'NOT FOUND')"
echo "ruff:    $(command -v ruff || echo 'NOT FOUND (likely in ~/.local/bin)')"

echo "[6/6] Verifying theme file exists..."
if [ -f "$THEMES_DIR/gruvbox_original_dark_hard.toml" ]; then
  echo "OK: Found $THEMES_DIR/gruvbox_original_dark_hard.toml"
else
  echo "WARNING: Did not find gruvbox_original_dark_hard.toml in $THEMES_DIR"
  echo "Available themes (first 50):"
  find "$THEMES_DIR" -maxdepth 2 -type f -name '*.toml' | sed 's#.*/##' | head -n 50
  echo
  echo "Pick one filename above (without .toml) and set: theme = \"<name>\""
fi

echo
echo "Done."
echo "Run: hx ."
echo "Test theme in Helix: :theme gruvbox_original_dark_hard"
echo
echo "If ruff isn't found, add this to your shell profile and restart terminal:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
