#!/usr/bin/env bash
set -euo pipefail

THEMES_URL="https://github.com/CptPotato/helix-themes/releases/download/latest/build.tar.gz"
HELIX_DIR="$HOME/.config/helix"
THEMES_DIR="$HELIX_DIR/themes"

echo "[1/5] Install Helix from PPA..."
sudo apt update
sudo apt install -y software-properties-common curl ca-certificates tar
sudo add-apt-repository -y ppa:maveonair/helix-editor
sudo apt update
sudo apt install -y helix

echo "[2/5] Install optional helpers..."
sudo apt install -y git ripgrep fd-find

echo "[3/5] Install Python LSP + formatter (uses existing Python, pip only)..."
python3 -m pip install --user -U "python-lsp-server[all]" ruff jedi

echo "[4/5] Install theme pack..."
mkdir -p "$THEMES_DIR"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -LfsS "$THEMES_URL" -o "$tmp/build.tar.gz"
tar -xzf "$tmp/build.tar.gz" -C "$THEMES_DIR"

echo "[5/5] Write Helix config + Python LSP config..."
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
language-servers = ["pylsp"]
auto-format = true
formatter = { command = "ruff", args = ["format", "-"] }

[language-server.pylsp]
command = "pylsp"
TOML

echo
echo "Done."
echo "Run: hx ."
echo
echo "Sanity checks:"
echo "  hx:    $(command -v hx || echo 'NOT FOUND')"
echo "  pylsp: $(command -v pylsp || echo 'NOT FOUND (usually ~/.local/bin/pylsp)')"
echo "  ruff:  $(command -v ruff || echo 'NOT FOUND (usually ~/.local/bin/ruff)')"
echo
echo "If Helix can't find pylsp/ruff, ensure this is in your shell profile and restart terminal:"
echo '  export PATH="$HOME/.local/bin:$PATH"'
