#!/usr/bin/env bash
# Moves dotfiles superseded by this nix-darwin setup out of $HOME and into
# a single dated backup folder. Nothing is ever deleted outright.
#
# Two modes, sharing one backup folder:
#
#   ./cleanup.sh            Non-interactive sweep of specific paths already
#                           confirmed stale. Safe to run unattended and more
#                           than once (a no-op for anything already moved).
#                           This is what bootstrap.sh calls automatically
#                           after every successful switch.
#
#   ./cleanup.sh --review   Also interactively reviews every other
#                           top-level $HOME dotfile not on the KNOWN_FINE
#                           allowlist below, showing a summary and
#                           prompting y/N per item. Needs a real terminal.
#                           Run this by hand occasionally to catch drift
#                           (new tools, one-off leftovers) that hasn't been
#                           individually confirmed stale yet -- update
#                           KNOWN_FINE as you adopt new tools, so routine
#                           installs stop showing up here.
#
# The two modes don't overlap: --review only looks at $HOME's top level,
# so it can't see specific nested paths like .config/alacritty or
# .local/bin/lvim -- those stay covered by the sweep below, inside
# directories (.config, .local, .claude) that are otherwise legitimate.
set -uo pipefail

BACKUP_DIR="$HOME/.dotfiles-legacy-backup-$(date +%Y%m%d-%H%M%S)"
moved_any=0

move_if_exists() {
  local path="$1"
  local rel="${path#"$HOME"/}"
  if [ -e "$path" ] || [ -L "$path" ]; then
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    mv "$path" "$BACKUP_DIR/$rel"
    echo "moved: $path"
    moved_any=1
  fi
}

# ---------------------------------------------------------------------------
# confirmed-stale sweep (always runs)
# ---------------------------------------------------------------------------

# home-manager's own backups of pre-existing files it wrote over during
# switch (backupFileExtension = "before-nix" in flake.nix)
move_if_exists "$HOME/.zshrc.before-nix"
move_if_exists "$HOME/.zshenv.before-nix"
move_if_exists "$HOME/.p10k.zsh.before-nix"
move_if_exists "$HOME/.tmux.conf.before-nix"
move_if_exists "$HOME/.config/nvim.before-nix"
move_if_exists "$HOME/.config/ghostty.before-nix"
move_if_exists "$HOME/.claude/settings.json.before-nix"
move_if_exists "$HOME/.claude/CLAUDE.md.before-nix"

# ---------------------------------------------------------------------------
# interactive review of everything else ($HOME's top level only)
# ---------------------------------------------------------------------------

if [ "${1:-}" = "--review" ]; then
  # Anything here is considered normal and is never flagged. Update this
  # list as you adopt new tools, so routine installs don't get flagged.
  KNOWN_FINE=(
    ".cache" ".cargo" ".CFUserTextEncoding" ".claude" ".claude.json"
    ".config" ".dotfiles" ".DS_Store" ".gem" ".homebrew" ".local"
    ".nix-defexpr" ".nix-profile" ".npm" ".npmrc" ".p10k.zsh" ".profile"
    ".rustup" ".ssh" ".terminfo" ".tmux.conf" ".Trash" ".yarnrc" ".zsh"
    ".zsh_history" ".zsh_sessions" ".zshenv" ".zshrc"
  )

  is_known_fine() {
    local name="$1"
    case "$name" in
      .dotfiles-legacy-backup-*) return 0 ;;
    esac
    local k
    for k in "${KNOWN_FINE[@]}"; do
      [ "$name" = "$k" ] && return 0
    done
    return 1
  }

  reviewed_any=0

  for path in "$HOME"/.*; do
    name="$(basename "$path")"
    [ "$name" = "." ] && continue
    [ "$name" = ".." ] && continue
    is_known_fine "$name" && continue
    reviewed_any=1

    echo
    echo "=== $name ==="
    if [ -d "$path" ]; then
      size=$(du -sh "$path" 2>/dev/null | cut -f1)
      count=$(find "$path" -type f 2>/dev/null | wc -l | tr -d ' ')
      mtime=$(stat -f '%Sm' -t '%Y-%m-%d' "$path" 2>/dev/null)
      echo "directory, $size, $count files, last modified $mtime"
      echo "top-level contents:"
      find "$path" -mindepth 1 -maxdepth 1 -exec basename {} \; 2>/dev/null | head -8 | sed 's/^/  /'
    else
      size=$(du -sh "$path" 2>/dev/null | cut -f1)
      mtime=$(stat -f '%Sm' -t '%Y-%m-%d' "$path" 2>/dev/null)
      kind=$(file -b "$path" 2>/dev/null)
      echo "file, $size, last modified $mtime, $kind"
      # preview small text files to help decide -- same due diligence as
      # manually checking .aws/.sentryclirc contents before removal
      if [ "$(du -k "$path" 2>/dev/null | cut -f1)" -lt 8 ] && [[ "$kind" == *text* ]]; then
        echo "--- contents ---"
        sed 's/^/  /' "$path" 2>/dev/null
      fi
    fi

    answer=""
    read -r -p "Move to backup? [y/N] " answer || answer="n"
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      rel="${path#"$HOME"/}"
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv "$path" "$BACKUP_DIR/$rel"
      echo "moved."
      moved_any=1
    else
      echo "kept."
    fi
  done

  if [ "$reviewed_any" = "0" ]; then
    echo
    echo "Nothing outside the known-fine list."
  fi
fi

if [ "$moved_any" = "1" ]; then
  echo
  echo "Moved items to: $BACKUP_DIR"
  echo "Review it, then remove when ready: rm -rf \"$BACKUP_DIR\""
else
  echo "Nothing to clean up."
  rmdir "$BACKUP_DIR" 2>/dev/null || true
fi
