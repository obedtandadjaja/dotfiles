{ pkgs, user, ... }:

{
  # Apple Silicon (M1 Pro). Note: `uname -m` may lie and say x86_64 when the
  # shell runs under Rosetta 2 — bootstrap.sh guards against that.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Determinate Nix manages the daemon and /etc/nix/nix.conf;
  # nix-darwin must not fight it over daemon/settings ownership.
  nix.enable = false;

  system.stateVersion = 6;
  system.primaryUser = user;

  users.users.${user} = {
    name = user;
    home = "/Users/${user}";
  };

  # Writes /etc/zshrc so every zsh picks up the nix environment;
  # the login shell stays /bin/zsh.
  programs.zsh.enable = true;

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # homebrew.enable below installs Homebrew non-interactively, so the
  # installer never gets a chance to add its own shellenv line to a
  # profile file - wire the prefix into PATH declaratively instead.
  environment.systemPath = [ "/opt/homebrew/bin" "/opt/homebrew/sbin" ];

  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
      NSAutomaticSpellingCorrectionEnabled = true;
      NSAutomaticCapitalizationEnabled = true;
      NSAutomaticDashSubstitutionEnabled = true;
      NSAutomaticQuoteSubstitutionEnabled = true;
      NSAutomaticPeriodSubstitutionEnabled = true;
      AppleMeasurementUnits = "Inches";
      AppleTemperatureUnit = "Celsius";
      AppleMetricUnits = 0;
      "com.apple.keyboard.fnState" = false;
      AppleKeyboardUIMode = 2; # full keyboard access: tab moves focus between all controls
    };
    dock = {
      autohide = true;
      tilesize = 37;
      largesize = 128;
      orientation = "left";
      mineffect = "genie";
      show-recents = false;
      launchanim = false;
      wvous-br-corner = 1; # raw macOS hot-corner action code, already set on this Mac
    };
    finder = {
      FXPreferredViewStyle = "Nlsv"; # list view by default
      CreateDesktop = false;         # clean desktop
      NewWindowTarget = "Home";      # new windows open to Home
    };
    trackpad = {
      Clicking = true; # tap to click
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };
    controlcenter.BatteryShowPercentage = true;
    loginwindow.GuestEnabled = false;
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap"; # remove anything not declared below
    };
    # fzf, ripgrep, tmux, neovim, node, zsh-autosuggestions, and
    # zsh-history-substring-search are intentionally left out: they're
    # already nix-managed in home.nix, so zap retires the redundant
    # homebrew copies instead of keeping two installs around.
    brews = [
      "ast-grep"
      "cmake"
      "docker"
      "gh"
      "git-delta"
      "golangci-lint"
      "helm"
      "k9s"
      "kubernetes-cli"
      "kustomize"
      "openjdk"
      "postgresql@14"
      "pre-commit"
      "python@3.10"
      "universal-ctags"
      "wget"
      "yarn"
    ];
    casks = [ "ghostty" "opensuperwhisper" "skim" ]; # skim: SyncTeX-aware PDF viewer for vimtex
  };
}
