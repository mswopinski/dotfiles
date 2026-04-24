# Dotfiles Setup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate zsh, tmux, ghostty, starship, and nvim configs into ~/workspace/dotfiles and manage them with GNU Stow, with tmux moving to its XDG location.

**Architecture:** Each app is a Stow "package" — a subdirectory whose contents mirror the target filesystem relative to `~`. Running `stow -t ~ <package>` from the dotfiles root creates symlinks. Config files are moved (not copied) so the source of truth immediately becomes the dotfiles repo.

**Tech Stack:** GNU Stow, zsh, git, brew

---

## File Map

| Dotfiles path | Symlinked to | Action |
|---|---|---|
| `zsh/.zshrc` | `~/.zshrc` | Move from `~/.zshrc` |
| `zsh/.zprofile` | `~/.zprofile` | Move from `~/.zprofile` |
| `tmux/.config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | Move from `~/.tmux.conf` (XDG migration) |
| `ghostty/.config/ghostty/config` | `~/.config/ghostty/config` | Move from `~/.config/ghostty/config` |
| `starship/.config/starship.toml` | `~/.config/starship.toml` | Move from `~/.config/starship.toml` |
| `nvim/.config/nvim/` | `~/.config/nvim/` | Create empty placeholder |
| `Brewfile` | (not stowed) | Generate via brew bundle dump |

---

### Task 1: Install GNU Stow

**Files:** none

- [ ] **Step 1: Install stow**

```bash
brew install stow
```

Expected output: `🍺  stow was successfully installed` (or `already installed`)

- [ ] **Step 2: Verify**

```bash
stow --version
```

Expected: version line like `stow (GNU Stow) 2.x.x`

- [ ] **Step 3: Commit current state of repo**

```bash
cd ~/workspace/dotfiles
git status
```

Expected: only the docs/ directory tracked so far.

---

### Task 2: Set up zsh package

**Files:**
- Create: `~/workspace/dotfiles/zsh/.zshrc`
- Create: `~/workspace/dotfiles/zsh/.zprofile`
- Symlinks: `~/.zshrc`, `~/.zprofile`

- [ ] **Step 1: Create package directory**

```bash
mkdir -p ~/workspace/dotfiles/zsh
```

- [ ] **Step 2: Move configs into package**

```bash
mv ~/.zshrc ~/workspace/dotfiles/zsh/.zshrc
mv ~/.zprofile ~/workspace/dotfiles/zsh/.zprofile
```

- [ ] **Step 3: Stow the package**

```bash
cd ~/workspace/dotfiles
stow -t ~ zsh
```

Expected: no output (silent = success)

- [ ] **Step 4: Verify symlinks**

```bash
ls -la ~/.zshrc ~/.zprofile
```

Expected output (both should show `->` pointing into dotfiles):
```
lrwxr-xr-x  1 mswopinski  staff  ...  .zprofile -> workspace/dotfiles/zsh/.zprofile
lrwxr-xr-x  1 mswopinski  staff  ...  .zshrc -> workspace/dotfiles/zsh/.zshrc
```

- [ ] **Step 5: Verify zsh still loads**

Open a new terminal tab or run:
```bash
source ~/.zshrc
echo $?
```

Expected: `0` (no errors)

- [ ] **Step 6: Commit**

```bash
cd ~/workspace/dotfiles
git add zsh/
git commit -m "feat: add zsh package"
```

---

### Task 3: Set up tmux package (with XDG migration)

**Files:**
- Create: `~/workspace/dotfiles/tmux/.config/tmux/tmux.conf`
- Symlink: `~/.config/tmux/tmux.conf`
- Removes: `~/.tmux.conf`

- [ ] **Step 1: Create package directory structure**

```bash
mkdir -p ~/workspace/dotfiles/tmux/.config/tmux
```

- [ ] **Step 2: Move config into XDG location inside package**

```bash
mv ~/.tmux.conf ~/workspace/dotfiles/tmux/.config/tmux/tmux.conf
```

- [ ] **Step 3: Remove old XDG dir if it exists (stow needs to create it)**

```bash
# Only if ~/.config/tmux exists and is empty
rmdir ~/.config/tmux 2>/dev/null || true
```

- [ ] **Step 4: Stow the package**

```bash
cd ~/workspace/dotfiles
stow -t ~ tmux
```

Expected: no output

- [ ] **Step 5: Verify symlink**

```bash
ls -la ~/.config/tmux/tmux.conf
```

Expected:
```
lrwxr-xr-x  ...  ~/.config/tmux/tmux.conf -> ../../../workspace/dotfiles/tmux/.config/tmux/tmux.conf
```

- [ ] **Step 6: Verify tmux loads config**

```bash
tmux new-session -d -s test && tmux kill-session -t test && echo "tmux ok"
```

Expected: `tmux ok`

- [ ] **Step 7: Commit**

```bash
cd ~/workspace/dotfiles
git add tmux/
git commit -m "feat: add tmux package (XDG migration from ~/.tmux.conf)"
```

---

### Task 4: Set up ghostty package

**Files:**
- Create: `~/workspace/dotfiles/ghostty/.config/ghostty/config`
- Symlink: `~/.config/ghostty/config`

- [ ] **Step 1: Create package directory structure**

```bash
mkdir -p ~/workspace/dotfiles/ghostty/.config/ghostty
```

- [ ] **Step 2: Move config into package**

```bash
mv ~/.config/ghostty/config ~/workspace/dotfiles/ghostty/.config/ghostty/config
```

- [ ] **Step 3: Remove now-empty ghostty dir so stow can recreate it**

```bash
rmdir ~/.config/ghostty
```

- [ ] **Step 4: Stow the package**

```bash
cd ~/workspace/dotfiles
stow -t ~ ghostty
```

Expected: no output

- [ ] **Step 5: Verify symlink**

```bash
ls -la ~/.config/ghostty/config
```

Expected:
```
lrwxr-xr-x  ...  ~/.config/ghostty/config -> ../../../workspace/dotfiles/ghostty/.config/ghostty/config
```

- [ ] **Step 6: Commit**

```bash
cd ~/workspace/dotfiles
git add ghostty/
git commit -m "feat: add ghostty package"
```

---

### Task 5: Set up starship package

**Files:**
- Create: `~/workspace/dotfiles/starship/.config/starship.toml`
- Symlink: `~/.config/starship.toml`

- [ ] **Step 1: Create package directory structure**

```bash
mkdir -p ~/workspace/dotfiles/starship/.config
```

- [ ] **Step 2: Move config into package**

```bash
mv ~/.config/starship.toml ~/workspace/dotfiles/starship/.config/starship.toml
```

- [ ] **Step 3: Stow the package**

```bash
cd ~/workspace/dotfiles
stow -t ~ starship
```

Expected: no output

- [ ] **Step 4: Verify symlink**

```bash
ls -la ~/.config/starship.toml
```

Expected:
```
lrwxr-xr-x  ...  ~/.config/starship.toml -> ../workspace/dotfiles/starship/.config/starship.toml
```

- [ ] **Step 5: Commit**

```bash
cd ~/workspace/dotfiles
git add starship/
git commit -m "feat: add starship package"
```

---

### Task 6: Set up nvim placeholder package

**Files:**
- Create: `~/workspace/dotfiles/nvim/.config/nvim/.gitkeep`
- Symlink: `~/.config/nvim/` (directory)

- [ ] **Step 1: Create package directory with gitkeep**

```bash
mkdir -p ~/workspace/dotfiles/nvim/.config/nvim
touch ~/workspace/dotfiles/nvim/.config/nvim/.gitkeep
```

- [ ] **Step 2: Remove existing nvim config dir if empty**

```bash
rmdir ~/.config/nvim 2>/dev/null || true
```

If `~/.config/nvim` exists and is NOT empty, do not remove it — move its contents into the package dir instead, then remove the original dir.

- [ ] **Step 3: Stow the package**

```bash
cd ~/workspace/dotfiles
stow -t ~ nvim
```

Expected: no output

- [ ] **Step 4: Verify symlink**

```bash
ls -la ~/.config/nvim
```

Expected: a symlink pointing into dotfiles

- [ ] **Step 5: Commit**

```bash
cd ~/workspace/dotfiles
git add nvim/
git commit -m "feat: add nvim placeholder package"
```

---

### Task 7: Generate Brewfile

**Files:**
- Create: `~/workspace/dotfiles/Brewfile`

- [ ] **Step 1: Generate Brewfile from current brew state**

```bash
cd ~/workspace/dotfiles
brew bundle dump --file=Brewfile
```

Expected: creates `Brewfile` with your current taps, brews, and casks.

- [ ] **Step 2: Review the output**

```bash
cat ~/workspace/dotfiles/Brewfile
```

Skim it — remove anything that looks like it was installed by accident or is no longer needed. The file is just text, edit freely.

- [ ] **Step 3: Commit**

```bash
cd ~/workspace/dotfiles
git add Brewfile
git commit -m "feat: add Brewfile snapshot"
```

---

### Task 8: Final verification

- [ ] **Step 1: Check all symlinks at a glance**

```bash
ls -la ~/.zshrc ~/.zprofile ~/.config/tmux/tmux.conf ~/.config/ghostty/config ~/.config/starship.toml ~/.config/nvim
```

All entries should show `->` pointing into `~/workspace/dotfiles/`.

- [ ] **Step 2: Check stow sees packages as installed**

```bash
cd ~/workspace/dotfiles
stow -t ~ --no -v zsh tmux ghostty starship nvim 2>&1
```

(`--no` is dry-run, `-v` is verbose) Expected: warnings about existing links (meaning they're already in place) — no errors about conflicts.

- [ ] **Step 3: Open a new Ghostty window**

Confirm the terminal still loads correctly with your theme and font.

- [ ] **Step 4: Start a tmux session**

```bash
tmux
```

Confirm your config loads (keybinds, theme, etc.).

- [ ] **Step 5: Final commit**

```bash
cd ~/workspace/dotfiles
git log --oneline
```

Expected: 7-8 commits showing the full migration history.
