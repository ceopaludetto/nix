{
  config,
  default,
  inputs,
  pkgs,
  system,
  ...
}:
{
  imports = [
    # Home Manager
    inputs.home-manager.darwinModules.home-manager

    # Homebrew
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.brew-nix.darwinModules.default

    # Theme
    ./utilities/theme/${system.triple}.nix
  ];

  # State version
  system.stateVersion = 6;

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Nix GC
  nix.gc.automatic = true;
  # nix.gc.interval = "@weekly";
  nix.gc.options = "--delete-older-than 30d";

  # Nix auto optimise store
  nix.optimise.automatic = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Add overlay for nix-vscode-extensions
  nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

  # Enable networking
  networking.hostName = "Carlos-MacBook-Pro";
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Thunderbolt Bridge"
    "USB 10/100/1000 LAN"
    "iPhone USB"
  ];

  # Enable firewall
  networking.applicationFirewall.enable = true;

  # Set time zone
  time.timeZone = "America/Sao_Paulo";

  # User account
  system.primaryUser = "carlos";
  users.users.carlos = {
    home = "/Users/carlos";
    description = "Carlos Paludetto";
  };

  # Enable brew casks to be used directly as packages
  brew-nix.enable = true;

  environment.systemPackages = with pkgs; [
    # Programs
    brewCasks.android-studio
    # brewCasks.craft
    brewCasks.betterdisplay
    brewCasks.iina
    brewCasks.intellij-idea
    brewCasks.raycast
    brewCasks.rectangle
    brewCasks.scroll-reverser
    brewCasks.slack
    brewCasks.the-unarchiver
    brewCasks.whatsapp
    brewCasks.utm
    brewCasks.yaak

    # NixOS related
    home-manager
  ];

  # Home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = { inherit default inputs system; };
  home-manager.users.carlos = import ./home/${system.triple}.nix;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
  ];

  # Dock configuration
  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-delay = 0.0;
  system.defaults.dock.magnification = true;
  system.defaults.dock.show-recents = false;
  system.defaults.dock.tilesize = 64;
  system.defaults.dock.largesize = 80;

  # Hot corners (disable all)
  system.defaults.dock.wvous-tl-corner = 1;
  system.defaults.dock.wvous-tr-corner = 1;
  system.defaults.dock.wvous-bl-corner = 1;
  system.defaults.dock.wvous-br-corner = 1;

  # Finder (show warning when changing extension)
  system.defaults.finder.FXEnableExtensionChangeWarning = false;

  # Finder (default view style)
  system.defaults.finder.FXPreferredViewStyle = "icnv";

  # Finder (common)
  system.defaults.finder.NewWindowTarget = "Other";
  system.defaults.finder.NewWindowTargetPath = "file:///Users/carlos/Developer";
  system.defaults.finder.ShowHardDrivesOnDesktop = true;
  system.defaults.finder.ShowPathbar = true;

  # Finder (folders first)
  system.defaults.finder._FXSortFoldersFirst = true;
  system.defaults.finder._FXSortFoldersFirstOnDesktop = true;

  # Clock
  system.defaults.menuExtraClock.ShowDate = 1;
  system.defaults.menuExtraClock.Show24Hour = true;

  # Trackpad
  system.defaults.trackpad.Clicking = true;
  system.defaults.trackpad.FirstClickThreshold = 0;
  system.defaults.trackpad.SecondClickThreshold = 0;
  system.defaults.trackpad.TrackpadRightClick = true;

  # Window manager
  system.defaults.WindowManager.EnableStandardClickToShowDesktop = false;
  system.defaults.WindowManager.StandardHideWidgets = true;

  # Always expand save and print panels
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
  system.defaults.NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
  system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
  system.defaults.NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;

  # Disable default command + space (use raycast instead)
  system.defaults.CustomUserPreferences.com.apple.symbolichotkeys."64".enabled = 0;

  # Allow sudo with touch id
  security.pam.services.sudo_local.enable = true;
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  # Install Homebrew through Nix
  nix-homebrew.enable = true;
  nix-homebrew.enableRosetta = true;

  nix-homebrew.user = "carlos";

  nix-homebrew.mutableTaps = false;
  nix-homebrew.taps = {
    "homebrew/homebrew-core" = inputs.homebrew-core;
    "homebrew/homebrew-cask" = inputs.homebrew-cask;
  };

  # Homebrew
  homebrew.enable = true;
  homebrew.onActivation.cleanup = "zap";

  # App Store
  homebrew.masApps = {
    "xcode" = 497799835;
  };

  # Brews
  homebrew.brews = [
    "cocoapods"
  ];

  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;

  # Pre activation script
  system.activationScripts."preActivation".text = ''
    if ! /usr/bin/pgrep -q oahd >/dev/null 2>&1; then
    	echo "[+] Installing Rosetta"
    	/usr/sbin/softwareupdate --install-rosetta --agree-to-license
    fi
  '';
}
