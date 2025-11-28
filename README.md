# Dotfiles

Cross-platform dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Features

- 🦀 **Rust-powered CLI tools** via cargo
- 🎨 **Modern shell** with oh-my-zsh + starship
- 📦 **Smart installations** - works on macOS and Ubuntu
- 🔧 **Git integration** with delta pager
- 🖥️ **Tmux** configuration
- ✨ **Neovim** basic setup

## Tools Installed

### Cargo Tools
- **ripgrep** (rg) - Fast grep
- **bat** - Cat with syntax highlighting  
- **eza** - Modern ls
- **zoxide** - Smart cd
- **git-delta** - Better git diffs
- **starship** - Fast prompt
- **fd-find** (fd) - Fast find
- **tokei** - Code statistics
- **du-dust** (dust) - Disk usage

### External Binaries
- **lazygit** - Git TUI
- **television** (tv) - Fuzzy finder
- **zed** - Code editor (preview)

### System Packages
- zsh
- tmux  
- fzf
- git
- neovim

## Quick Start

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Initialize with this repo (replace with your repo URL)
chezmoi init https://github.com/yourusername/dotfiles.git

# Preview what would change
chezmoi diff

# Apply changes
chezmoi apply
```

During `init`, you'll be prompted for:
- Git user name
- Git email

## Usage

### Daily Commands

```bash
# Edit a file
chezmoi edit ~/.zshrc

# See what changed
chezmoi diff

# Apply changes
chezmoi apply

# Add a new file to manage
chezmoi add ~/.config/newapp/config.toml
```

### Updating Tools

```bash
# Update cargo tools
cargo install <tool> --force

# Update externals (lazygit, television)
chezmoi upgrade

# Update system packages
brew upgrade        # macOS
sudo apt upgrade    # Ubuntu
```

### Tool Quick Reference

```bash
# Search files
rg "pattern"
rg "pattern" --type rust

# View file with syntax highlighting
bat filename.rs

# List files
eza -la
eza --tree

# Search and cd
z partial-dir-name

# Disk usage
dust

# Code statistics
tokei

# Git TUI
lg

# Fuzzy finder
tv
```

## Structure

```
.
├── .chezmoi.toml.tmpl                      # Main config
├── .chezmoiexternal.toml.tmpl              # External binaries
├── run_once_before_*                       # Installation scripts
├── run_after_*                             # Post-install scripts
├── dot_zshrc.tmpl                          # ~/.zshrc
├── dot_tmux.conf                           # ~/.tmux.conf
└── dot_config/                             # ~/.config/
    ├── git/
    │   ├── config.tmpl
    │   └── ignore
    ├── starship.toml
    ├── bat/
    ├── nvim/
    └── ...
```

## Customization

### Updating Versions

Edit `.chezmoi.toml.tmpl` and change version numbers:

```toml
[data]
    lazygit_version = "0.43.1"  # Update here
```

Then run `chezmoi apply`.

### Adding Cargo Tools

Add to `cargo_tools` list in `.chezmoi.toml.tmpl`:

```toml
cargo_tools = [
    "ripgrep",
    # ... existing tools ...
    "your-new-tool",
]
```

And add to `cargo_commands` map for verification:

```toml
[data.cargo_commands]
    your-new-tool = "command-name"
```

### Platform-Specific Config

Use templates with conditionals:

```bash
{{- if eq .chezmoi.os "darwin" }}
# macOS-specific
{{- else if eq .osid "ubuntu" }}
# Ubuntu-specific
{{- end }}
```

## Troubleshooting

### Cargo compilation is slow
First install takes 10-20 minutes - this is normal. Binaries are compiled from source.

### oh-my-zsh overwrote my .zshrc
Ensure `KEEP_ZSHRC=yes` is set in the installation script.

### Shell not changing
Run `chsh -s $(which zsh)` manually, then log out and back in.

### Verification shows missing tools
Check installation logs in the specific `run_once_*` script output.

## License

MIT
