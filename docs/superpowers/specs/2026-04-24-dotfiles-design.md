# Dotfiles Setup Design

**Date:** 2026-04-24  
**Tool:** GNU Stow  
**Target:** ~/workspace/dotfiles

---

## Goal

Centralize personal config files into a single version-controlled repository at `~/workspace/dotfiles`, managed with GNU Stow for symlink creation. Where possible, configs follow the XDG Base Directory Specification (`~/.config/<app>/`).

---

## Directory Structure

```
~/workspace/dotfiles/
├── zsh/
│   ├── .zshrc
│   └── .zprofile
├── tmux/
│   └── .config/tmux/tmux.conf
├── ghostty/
│   └── .config/ghostty/config
├── starship/
│   └── .config/starship.toml
├── nvim/
│   └── .config/nvim/          (empty placeholder, populated when nvim is configured)
├── git/
│   └── .config/git/config     (future)
├── Brewfile                   (not stowed, version-controlled only)
└── docs/
    └── superpowers/specs/
        └── 2026-04-24-dotfiles-design.md
```

---

## How Stow Works

GNU Stow is run from `~/workspace/dotfiles`. Each subdirectory is a "package". Running:

```sh
stow -t ~ <package>
```

strips the package directory name and creates symlinks relative to `~`. For example:

- `dotfiles/zsh/.zshrc` → `~/.zshrc`
- `dotfiles/tmux/.config/tmux/tmux.conf` → `~/.config/tmux/tmux.conf`
- `dotfiles/ghostty/.config/ghostty/config` → `~/.config/ghostty/config`

To remove symlinks: `stow -D -t ~ <package>`

---

## XDG Compliance

| App      | XDG Native | Location After Migration         | Notes                              |
|----------|-----------|----------------------------------|------------------------------------|
| zsh      | No        | `~/.zshrc`, `~/.zprofile`        | XDG workaround exists but skipped  |
| tmux     | Yes       | `~/.config/tmux/tmux.conf`       | Moved from `~/.tmux.conf`          |
| ghostty  | Yes       | `~/.config/ghostty/config`       | Already in correct location        |
| starship | Yes       | `~/.config/starship.toml`        | Already in correct location        |
| nvim     | Yes       | `~/.config/nvim/`                | Placeholder only                   |
| git      | Yes       | `~/.config/git/config`           | Future addition                    |

zsh predates XDG by ~13 years. The `.zshenv` + `ZDOTDIR` workaround exists but adds complexity with no practical benefit for a single-machine setup.

---

## Migration Steps (per package)

1. Create the target directory structure inside `dotfiles/`
2. Move (not copy) the existing config file into place
3. Remove any now-empty original directories
4. Run `stow -t ~ <package>` from `~/workspace/dotfiles`
5. Verify the symlink resolves correctly

For tmux specifically: move `~/.tmux.conf` → `dotfiles/tmux/.config/tmux/tmux.conf` (XDG migration included).

---

## Additional Files

- **Brewfile** — generated via `brew bundle dump`, tracked in git but not stowed (it's a snapshot, not a config to symlink)
- **git config** — future package; `~/.config/git/config` is XDG-native and worth tracking

---

## Bootstrap Command Reference

```sh
cd ~/workspace/dotfiles
stow -t ~ zsh
stow -t ~ tmux
stow -t ~ ghostty
stow -t ~ starship
stow -t ~ nvim
```

---

## What's Not Included

- SSH config (`~/.ssh/config`) — sensitive, skip
- Cursor/VS Code settings — managed by the app's sync
- `.zshenv` — not needed since we're not doing XDG for zsh
