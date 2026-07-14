{ config, pkgs, lib, user, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
  # Edit-in-place symlink: the real file stays in this repo, so config
  # tweaks under home/ take effect without a rebuild.
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/${path}";
in
{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    tmux
    nodejs
    neovim # plain package: programs.neovim's own config-file management
           # (even with zero plugins) collides with our out-of-store
           # home.file."./config/nvim" symlink below
    go
    gotools # goimports, run by conform.nvim on save
    prettier # nodePackages.* was removed in nixpkgs 26.05; top-level now
    imagemagick # image.nvim's magick_cli processor
    mermaid-cli # mmdc, used by diagram.nvim to render mermaid blocks
    tree-sitter # nvim-treesitter's "main" branch shells out to `tree-sitter
                # build` (needs >=0.26.1) to compile parsers from source
    (texlive.combine { # latex + latexmk for vimtex; scheme-basic lacks
                        # latexmk itself plus common packages. scheme-medium
                        # covers most of them but not enumitem, so it's
                        # added explicitly rather than jumping to scheme-full.
      inherit (texlive) scheme-medium enumitem;
    })

    # Language servers managed by nix instead of mason, so they roll
    # back with the generation and stay pinned with everything else.
    gopls
    typescript-language-server
    typescript
    basedpyright
    lua-language-server
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GOPATH = "${config.home.homeDirectory}/go";
  };
  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.local/bin" # claude, getnf
    "$HOME/.cargo/bin"
    # /usr/local/bin removed: it was a no-op duplicate of what macOS's
    # own path_helper (/etc/zprofile, via /etc/paths) already puts on
    # $PATH ahead of the Nix profile dirs. Removing it here doesn't
    # change ordering - if a stray /usr/local/bin install ever shadows
    # a Nix-managed tool again (as an old yarn-global tree-sitter-cli
    # once did), the fix is to remove that stray install, not this list.
  ];

  programs.fzf.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true; # up/down arrows search history by prefix
    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreAllDups = true;
    };
    shellAliases = {
      ".." = "cd ..";
      cf = "cd ~/code";
      cgo = "cd $GOPATH";
      k = "kubectl";
      be = "bundle exec";
      vim = "nvim";
      cc = "claude --dangerously-skip-permissions";
      apply_gitignore = "git ls-files -ci --exclude-standard -z | xargs -0 git rm --cached";
    };
    initContent = lib.mkMerge [
      # instant prompt must run before everything else in .zshrc
      (lib.mkOrder 500 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')
      ''
      # powerlevel10k prompt; tweak with `p10k configure` (writes ~/.p10k.zsh,
      # which is symlinked into this repo)
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      # attach to (or create) a named tmux session
      work() { tmux new-session -A -s ''${1:-work}; }

      # what app is listening on a port
      whichapp() { lsof -i tcp:$1; }
      ''
    ];
  };

  programs.delta = {
    enable = true; # nicer diffs: side-by-side, syntax highlighted
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Obed Tandadjaja";
        email = "obed.tandadjaja@gmail.com";
      };
      alias = {
        lol = ''log --pretty=format:"%C(yellow)%h%Creset%C(cyan)%C(bold)%d%Creset %s" --abbrev-commit --graph --decorate'';
        lola = "log --pretty=oneline --abbrev-commit --graph --decorate --all";
      };
      branch.sort = "-committerdate";
      credential.helper = "osxkeychain";
      init.defaultBranch = "master";
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  # Every entry mirrors the repo's home/ tree onto $HOME 1:1 through the
  # same out-of-store symlink, so config lives in one place and edits
  # under home/ take effect immediately with no rebuild.
  home.file.".p10k.zsh".source = link ".p10k.zsh";
  home.file.".tmux.conf".source = link ".tmux.conf";
  home.file.".config/nvim".source = link ".config/nvim";
  home.file.".config/ghostty".source = link ".config/ghostty";
  home.file.".claude/settings.json".source = link ".claude/settings.json";
  # AGENTS.md is the one hub file: one source, symlinked wherever a
  # coding agent looks for global instructions.
  home.file.".claude/CLAUDE.md".source = link "AGENTS.md";
}
