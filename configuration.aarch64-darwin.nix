{
  inputs,
  pkgs,
  system,
  ...
}: {
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.stylix.darwinModules.stylix

    ./utilities/stylix/${system.triple}.nix
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Add overlay for nix-vscode-extensions
  nixpkgs.overlays = [inputs.nix-vscode-extensions.overlays.default];

  # Enable networking
  networking.hostName = "Carlos-MacBook-Pro";
  networking.knownNetworkServices = ["Wi-Fi" "Thunderbolt Bridge" "USB 10/100/1000 LAN" "iPhone USB"];

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

  environment.systemPackages = with pkgs; [
    # NixOS related
    alejandra
    home-manager
    nixd
  ];

  # Home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = {inherit inputs system;};
  home-manager.users.carlos = import ./home/${system.triple}.nix;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
  ];

  # Dock configuration
  system.defaults.dock.autohide = true;
  system.defaults.dock.autohide-delay = 0.0;
  system.defaults.dock.magnification = true;

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

  # Allow sudo with touch id
  security.pam.services.sudo_local.enable = true;

  # Homebrew
  homebrew.enable = true;
  homebrew.casks = [
    "whatsapp"
  ];
  homebrew.masApps = {
    "craft" = 1487937127;
  };
}
