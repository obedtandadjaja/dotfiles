#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles

# sudo's secure_path ignores the caller's $PATH, so darwin-rebuild (installed
# into the system profile by the first switch) has to be resolved to an
# absolute path before handing it to sudo - the same fix bootstrap.sh already
# applies for `nix` itself.
DARWIN_REBUILD="$(command -v darwin-rebuild || true)"
if [ -z "$DARWIN_REBUILD" ]; then
  DARWIN_REBUILD="/run/current-system/sw/bin/darwin-rebuild"
fi
exec sudo "$DARWIN_REBUILD" switch --flake ~/.dotfiles#mac
