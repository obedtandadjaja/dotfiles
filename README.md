# Dotfiles

My macOS setup, managed declaratively with [Nix](https://nixos.org/) via
[nix-darwin](https://github.com/nix-darwin/nix-darwin) and
[home-manager](https://github.com/nix-community/home-manager).

## What's in the box

| Piece | Choice |
|---|---|
| Terminal | Ghostty (tokyonight, JetBrainsMono Nerd Font) |
| Shell | zsh + powerlevel10k prompt, autosuggestions, syntax highlighting |
| Agents | Claude Code (shared `AGENTS.md`) |
| Editor | Neovim, fresh Lua config with lazy.nvim |
| Multiplexer | tmux (prefix `C-Space`, secondary `C-a`) |
| Packages & LSPs | nix (ripgrep, fd, jq, fzf, gopls, ts, pyright, lua) |
| GUI apps | Homebrew casks driven by nix-darwin |

## Layout

```
flake.nix           # entry point: pins nixpkgs/nix-darwin/home-manager
configuration.nix   # system level: fonts, homebrew casks, /etc/zshrc
home.nix            # user level: packages, zsh, git, and symlinks below
home/               # mirrors $HOME 1:1 — every path here is symlinked
                    # to the identical path under $HOME (see home.nix)
├── .config/nvim/       # Neovim (lazy.nvim + lspconfig + telescope + treesitter)
├── .config/ghostty/    # Ghostty terminal
├── .claude/settings.json  # Claude Code settings
├── .claude/CLAUDE.md      # -> AGENTS.md (see below)
├── .p10k.zsh           # powerlevel10k prompt (edit via `p10k configure`)
├── .tmux.conf          # tmux
└── AGENTS.md           # global instructions for coding agents; symlinked
                         # wherever a given agent looks for them (currently
                         # just ~/.claude/CLAUDE.md)
bootstrap.sh        # fresh-machine setup
rebuild.sh          # apply changes
cleanup.sh          # move superseded config out of the way (see below)
```

## Setup (fresh machine)

Run these in order, in a real terminal (not a `!`-passthrough — some of
these need to prompt for your password interactively).

**1. Homebrew.** If this Mac is Apple Silicon, force a native install —
if the installer runs under Rosetta it silently reinstalls onto an old
Intel prefix instead of creating a new one at `/opt/homebrew`:

```sh
arch -arm64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Ignore any `.zprofile`/`brew shellenv` instructions it prints at the end —
nix-darwin's homebrew module sources that itself once you switch, so
nothing needs to be added by hand.

**2. Clone and bootstrap:**

```sh
git clone git@github.com:obedtandadjaja/dotfiles.git ~/code/dotfiles
cd ~/code/dotfiles
./bootstrap.sh
```

`bootstrap.sh` is idempotent and handles the rest itself:
installs Determinate Nix if missing (re-execing natively if this shell is
Rosetta-translated), symlinks the repo to `~/.dotfiles`, adopts an
already-installed Ghostty.app into Homebrew if needed, moves a real
(non-symlink) `~/.config/nvim` out of the way, then runs the first
`darwin-rebuild switch` — the one step that needs `sudo`, so watch for the
password prompt. Once that succeeds, it automatically runs `cleanup.sh`
(non-interactive mode; see below) and exits.

**3. Open a new terminal window.** The switch rewrites shell startup
files; your current terminal won't pick that up.

**Order matters:** step 1 before step 2 — `bootstrap.sh` will fail with
`Using the homebrew module requires homebrew installed` if Homebrew isn't
present yet. And within step 2, `bootstrap.sh` has to succeed at least
once before `rebuild.sh` works at all — `darwin-rebuild` isn't a real
installed command until that first switch completes (`bootstrap.sh` runs
it through `nix run`, which needs no pre-installed command). Skipping
straight to `rebuild.sh` on a never-switched machine fails with
`sudo: darwin-rebuild: command not found`.

## Daily use

- **Changed a `.nix` file** (`flake.nix`, `configuration.nix`, `home.nix`)?
  ```sh
  cd ~/code/dotfiles && ./rebuild.sh
  ```
  Needs `sudo`. Requires `./bootstrap.sh` to have succeeded at least once
  on this machine (see Setup).
- **Changed nvim / ghostty / tmux / p10k / claude config under `home/`?**
  Nothing to run — those paths are symlinked in place, so edits are live
  immediately. Just `git add`/`commit` when happy.
- **Update pinned nixpkgs/nix-darwin/home-manager versions:**
  ```sh
  cd ~/code/dotfiles && nix flake update && ./rebuild.sh
  ```
- **Check a change evaluates before switching (no `sudo`, touches
  nothing):**
  ```sh
  nix flake check --no-build
  ```
- **Full dry-run build, still no `sudo` and no system changes** (catches
  more than `flake check`, since it fully evaluates activation scripts):
  ```sh
  nix build ".#darwinConfigurations.mac.system" --no-link
  ```
- **Re-run the superseded-config sweep by hand** (safe — idempotent, only
  moves what's still present, no interaction needed):
  ```sh
  cd ~/code/dotfiles && ./cleanup.sh
  ```
- **Audit `$HOME` for anything else that's crept in** — also runs the
  sweep above, then interactively prompts per top-level item not on the
  `KNOWN_FINE` allowlist near the bottom of the script; update that list
  as you adopt new tools so routine installs stop showing up here:
  ```sh
  cd ~/code/dotfiles && ./cleanup.sh --review
  ```

## Troubleshooting

- **`error: Using the homebrew module requires homebrew installed`** —
  Homebrew isn't installed at the prefix this Mac's architecture expects
  (`/opt/homebrew` on Apple Silicon, `/usr/local` on Intel). See Setup
  step 1.
- **`sudo: darwin-rebuild: command not found`** — `./bootstrap.sh` hasn't
  succeeded on this machine yet; run it instead of `rebuild.sh` (see
  Setup).
- **`zsh: no such file or directory: ~/.zprofile`** while installing
  Homebrew — harmless; that's just the installer's generic advice to add
  `brew shellenv` to a profile file that doesn't exist here. Skip it;
  nix-darwin handles this itself.
- **Homebrew installer targeted `/usr/local` instead of `/opt/homebrew`
  on an Apple Silicon Mac** — it ran under Rosetta and mis-detected the
  architecture. Re-run with `arch -arm64` prefixed, as in Setup step 1.

## Notes

- This machine is Apple Silicon (M1 Pro) but was migrated from an Intel Mac,
  so the pre-nix Homebrew/tools at `/usr/local` are x86_64 under Rosetta 2 —
  which makes `uname -m` lie in translated shells. The flake targets
  `aarch64-darwin` and `bootstrap.sh` re-execs natively if needed; everything
  nix installs is native ARM.
- Login shell stays `/bin/zsh`; nix-darwin's `/etc/zshrc` wires up the nix
  environment, and home-manager owns `~/.zshrc`.
- `work [name]` attaches to (or creates) a tmux session. To auto-attach on
  every new shell, add `[ -z "$TMUX" ] && work` to `programs.zsh.initContent`.
- Homebrew casks/brews not declared in `configuration.nix` get removed on
  activation (`cleanup = "zap"`) — anything still needed from Homebrew has
  to be listed there explicitly, not installed ad hoc with `brew install`.
- Language servers are nix packages (no mason) so they version and roll back
  with the rest of the system.
