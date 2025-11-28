# Quick Start Guide

## What You Have

A complete dotfiles setup with:
- ✅ Zero duplication (single source of truth in `.chezmoi.toml.tmpl`)
- ✅ Cargo-first tool installation
- ✅ Cross-platform (macOS + Ubuntu)
- ✅ Modern shell (zsh + oh-my-zsh + starship)
- ✅ Git with delta pager
- ✅ Tmux configuration
- ✅ 9 Rust CLI tools (rg, bat, eza, zoxide, delta, starship, fd, tokei, dust)

## Get Started

### 1. Initialize Git Repo

```bash
cd ~/.local/share/chezmoi
git init
git add .
git commit -m "Initial dotfiles setup"
```

### 2. Push to GitHub

Create a new repo on GitHub (e.g., `dotfiles`), then:

```bash
git remote add origin https://github.com/YOUR_USERNAME/dotfiles.git
git branch -M main
git push -u origin main
```

### 3. Test on Current Machine

```bash
# Preview what would change
chezmoi diff

# Apply (this will run all installations)
chezmoi apply

# You'll be prompted for:
# - Git user name
# - Git email
```

**Note:** First run takes 10-20 minutes (cargo compilation).

### 4. On a New Machine

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Initialize and apply in one go
chezmoi init --apply https://github.com/YOUR_USERNAME/dotfiles.git
```

## Common Tasks

### Edit Config Files

```bash
# Edit zshrc
chezmoi edit ~/.zshrc

# Edit git config
chezmoi edit ~/.config/git/config

# Apply changes
chezmoi apply
```

### Add New Files

```bash
# Add a file to be managed
chezmoi add ~/.config/app/config.toml

# Commit to git
cd ~/.local/share/chezmoi
git add .
git commit -m "Add app config"
git push
```

### Update Tool Versions

Edit `.chezmoi.toml.tmpl`:

```toml
[data]
    lazygit_version = "0.44.0"  # Update this
```

Then:

```bash
chezmoi apply
```

### Add a New Cargo Tool

Edit `.chezmoi.toml.tmpl`:

```toml
cargo_tools = [
    "ripgrep",
    # ... existing tools ...
    "hyperfine",  # Add new tool
]

[data.cargo_commands]
    # ... existing mappings ...
    hyperfine = "hyperfine"  # Add mapping
```

Then:

```bash
chezmoi apply
```

The installation and verification scripts automatically pick it up!

## Troubleshooting

### Check Setup Validity

```bash
cd ~/.local/share/chezmoi
./verify-setup.sh
```

### See What Would Change

```bash
chezmoi diff
```

### Dry Run (Don't Actually Apply)

```bash
chezmoi apply --dry-run --verbose
```

### Force Re-run Installation Scripts

```bash
# Remove state tracking
rm ~/.local/share/chezmoi/.chezmoiscripts/

# Re-apply
chezmoi apply
```

## What Gets Installed

### Cargo Tools (via Rust)
- `rg` - Fast search
- `bat` - Better cat
- `eza` - Better ls
- `zoxide` - Smart cd
- `delta` - Better git diff
- `starship` - Prompt
- `fd` - Fast find
- `tokei` - Code stats
- `dust` - Disk usage

### External Binaries
- `lazygit` - Git TUI
- `tv` - Fuzzy finder
- `zed` - Editor

### System Packages
- zsh, tmux, fzf, git, neovim

### Configs
- Git (with delta)
- Zsh (with oh-my-zsh + starship)
- Tmux
- Neovim (basic)
- Bat
- Starship

## File Locations After Apply

```
~/
├── .zshrc                    # Shell config
├── .tmux.conf                # Tmux config
├── .config/
│   ├── git/
│   │   ├── config            # Git config with delta
│   │   └── ignore            # Global gitignore
│   ├── starship.toml         # Prompt config
│   ├── bat/config            # Bat config
│   └── nvim/init.lua         # Neovim config
└── .local/bin/               # All binaries
    ├── rg, bat, eza, ...     # Cargo tools
    ├── lazygit, tv           # External binaries
    └── zed                   # Zed editor
```

## Learn More

- Read `README.md` for full documentation
- Read `SETUP.md` for architecture details
- Visit https://www.chezmoi.io/ for chezmoi docs

## Pro Tips

1. **Alias for quick edits:**
   ```bash
   alias ce='chezmoi edit'
   alias ca='chezmoi apply'
   ```

2. **Auto-commit changes:**
   ```bash
   cd ~/.local/share/chezmoi
   chezmoi cd
   git add . && git commit -m "Update configs" && git push
   ```

3. **Keep tools updated:**
   ```bash
   # Update all cargo tools
   cargo install-update -a  # Requires: cargo install cargo-update
   ```

Happy dotfile management! 🎉
