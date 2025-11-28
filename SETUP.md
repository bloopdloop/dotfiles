# Setup Summary

This chezmoi configuration follows the principle of **zero duplication**.

## Key Design Decisions

### 1. Single Source of Truth

All tool definitions live in `.chezmoi.toml.tmpl`:

```toml
[data]
    # Cargo tools list - referenced everywhere
    cargo_tools = ["ripgrep", "bat", "eza", ...]
    
    # Command mappings for verification
    [data.cargo_commands]
        ripgrep = "rg"
        bat = "bat"
        ...
```

### 2. Template-Driven Installation

The cargo installation script loops through the config:

```bash
CARGO_TOOLS=(
{{- range .cargo_tools }}
    "{{ . }}"
{{- end }}
)

for tool in "${CARGO_TOOLS[@]}"; do
    cargo install "$tool" --locked
done
```

### 3. Template-Driven Verification

The verification script also loops:

```bash
{{- range $crate, $cmd := .cargo_commands }}
if command -v {{ $cmd }} &> /dev/null; then
    echo "  ✓ {{ $crate }} ({{ $cmd }})"
fi
{{- end }}
```

## File Structure

```
~/.local/share/chezmoi/
├── Configuration
│   ├── .chezmoi.toml.tmpl              # Main config (single source of truth)
│   ├── .chezmoiexternal.toml.tmpl      # External binaries (lazygit, tv)
│   └── .chezmoiignore                  # Files to ignore
│
├── Installation Scripts (run in order)
│   ├── run_once_before_01-install-packages.sh.tmpl
│   ├── run_once_before_02-install-rust.sh.tmpl
│   ├── run_once_before_03-install-cargo-tools.sh.tmpl    # Loops through config
│   ├── run_once_before_04-install-oh-my-zsh.sh.tmpl
│   ├── run_once_install-zed.sh.tmpl
│   └── run_after_configure-shell.sh.tmpl                 # Loops through config
│
└── Dotfiles
    ├── dot_zshrc.tmpl                  # ~/.zshrc
    ├── dot_tmux.conf                   # ~/.tmux.conf
    └── dot_config/                     # ~/.config/
        ├── git/
        │   ├── config.tmpl             # Uses {{ .git_name }} and {{ .git_email }}
        │   └── ignore
        ├── starship.toml
        ├── bat/config
        └── nvim/init.lua
```

## Installation Flow

1. **System Packages** - Install minimal system dependencies
2. **Rust** - Install via rustup
3. **Cargo Tools** - Compile and install all Rust tools (10-20 min)
4. **Oh-My-Zsh** - Install with plugins
5. **Zed** - Platform-specific installation
6. **Verification** - Check all tools installed correctly

## Adding New Tools

### Add a Cargo Tool

1. Edit `.chezmoi.toml.tmpl`:
   ```toml
   cargo_tools = [
       # ... existing ...
       "new-tool",
   ]
   
   [data.cargo_commands]
       new-tool = "command-name"
   ```

2. Run: `chezmoi apply`

That's it! The installation and verification scripts automatically pick it up.

### Add an External Binary

1. Add to `.chezmoiexternal.toml.tmpl`:
   ```toml
   [".local/bin/tool"]
       type = "archive-file"
       url = "https://..."
       executable = true
   ```

2. Optionally add verification to `run_after_configure-shell.sh.tmpl`

## Platform Support

Templates handle platform differences:

```bash
{{- if eq .chezmoi.os "darwin" }}
# macOS-specific
{{- else if eq .osid "ubuntu" }}
# Ubuntu-specific
{{- end }}
```

## Next Steps

1. Initialize a git repo:
   ```bash
   cd ~/.local/share/chezmoi
   git init
   git add .
   git commit -m "Initial dotfiles"
   ```

2. Push to GitHub:
   ```bash
   git remote add origin https://github.com/yourusername/dotfiles.git
   git push -u origin main
   ```

3. On a new machine:
   ```bash
   chezmoi init https://github.com/yourusername/dotfiles.git
   chezmoi apply
   ```

## Testing

Test on a fresh system (Ubuntu example):

```bash
docker run -it ubuntu:22.04 bash

# In container:
apt update && apt install -y curl
sh -c "$(curl -fsLS get.chezmoi.io)"
chezmoi init https://github.com/yourusername/dotfiles.git
chezmoi apply
```
