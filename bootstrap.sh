#!/usr/bin/env bash
# One-time setup on a fresh (or first-time-nix) machine.
# After this, use ./rebuild.sh to apply changes.
set -euo pipefail

# This Mac is Apple Silicon; if invoked from a Rosetta (x86_64) shell the
# nix installer would pick the wrong architecture — re-exec natively.
if [ "$(sysctl -n sysctl.proc_translated 2>/dev/null || echo 0)" = "1" ]; then
  exec arch -arm64 /usr/bin/env bash "$0" "$@"
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 1. Install Determinate Nix if missing
if ! command -v nix >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -fsSL https://install.determinate.systems/nix \
    | sh -s -- install --determinate --no-confirm
  # make nix available in this shell without restarting it
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# 2. Stable path the flake references regardless of where the repo lives
ln -sfn "$DIR" ~/.dotfiles

# 3. Adopt a manually-installed Ghostty.app into Homebrew so the cask
#    declaration in configuration.nix doesn't collide with it
if [ -d "/Applications/Ghostty.app" ] && ! brew list --cask ghostty >/dev/null 2>&1; then
  brew install --cask ghostty --adopt
fi

# home-manager backs up plain files in the way, but a pre-existing real
# directory can abort the switch — move the old nvim config aside once
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.before-nix"
fi

# 4. First build + switch (installs darwin-rebuild for subsequent runs)
sudo nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/.dotfiles#mac

# 5. Only reached if the switch above succeeded — move files superseded by
#    the new setup out of the way (see cleanup.sh for exactly what and
#    why; nothing is deleted, just moved into a dated backup folder).
#    Non-interactive mode only; run `./cleanup.sh --review` by hand
#    whenever you want to audit for anything else that's crept in.
"$DIR/cleanup.sh"
