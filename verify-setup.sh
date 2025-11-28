#!/bin/bash
# Quick verification that our chezmoi setup is valid

set -e

echo "Verifying chezmoi setup..."
echo ""

# Check required files exist
REQUIRED_FILES=(
    ".chezmoi.toml.tmpl"
    ".chezmoiexternal.toml.tmpl"
    ".chezmoiignore"
    "dot_zshrc.tmpl"
    "dot_tmux.conf"
    "run_once_before_01-install-packages.sh.tmpl"
    "run_once_before_02-install-rust.sh.tmpl"
    "run_once_before_03-install-cargo-tools.sh.tmpl"
    "run_once_before_04-install-oh-my-zsh.sh.tmpl"
    "run_after_configure-shell.sh.tmpl"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "✗ $file - MISSING"
        exit 1
    fi
done

echo ""
echo "✓ All required files present"
echo ""

# Check that scripts reference the config (no duplication)
echo "Checking for duplication..."

# Check cargo tools installation script uses template loop
if grep -q "{{- range .cargo_tools }}" "run_once_before_03-install-cargo-tools.sh.tmpl"; then
    echo "✓ Cargo installation uses config loop"
else
    echo "✗ Cargo installation doesn't use config loop"
    exit 1
fi

# Check verification script uses template loop
if grep -q "{{- range \$crate, \$cmd := .cargo_commands }}" "run_after_configure-shell.sh.tmpl"; then
    echo "✓ Verification uses config loop"
else
    echo "✗ Verification doesn't use config loop"
    exit 1
fi

echo ""
echo "✓ Setup verified - no duplication detected!"
echo ""
echo "Next steps:"
echo "  1. git init && git add . && git commit -m 'Initial dotfiles'"
echo "  2. Push to your GitHub repo"
echo "  3. Test: chezmoi init --apply <your-repo-url>"
