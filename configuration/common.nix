{
  config,
  default,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
{
  imports = [
    # Home Manager
    inputs.home-manager.nixosModules.home-manager

    # SOPS
    inputs.sops.nixosModules.sops

    # Niri
    inputs.niri.nixosModules.niri

    # DMS greeter
    inputs.dms.nixosModules.greeter

    # Load age secrets
    ../utilities/secrets.nix
  ];

  # Nix settings
  nix.settings.auto-optimise-store = true;
  nix.settings.warn-dirty = false;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Nix GC
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";

  # Nix auto optimise store
  nix.optimise.automatic = true;

  # Disable documentation
  documentation.nixos.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  # Allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
    "python-2.7.18.12"
  ];

  # Add overlay for nix-vscode-extensions
  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
    inputs.niri.overlays.niri
  ];

  # Set time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "pt_BR.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Fix time in Windows
  time.hardwareClockInLocalTime = true;

  # Disable X11 server
  services.xserver.enable = lib.mkForce false;

  # Enable Niri
  programs.niri.enable = true;

  # Enable UWSM
  programs.uwsm.enable = true;
  programs.uwsm.package = pkgs.uwsm.override { uuctlSupport = false; };
  programs.uwsm.waylandCompositors = {
    niri.prettyName = "Niri";
    niri.comment = "Niri compositor managed by UWSM";
    niri.binPath = "/run/current-system/sw/bin/niri";
    niri.extraArgs = [ "--session" ];
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User account
  users.defaultUserShell = pkgs.zsh;
  users.users.carlos = {
    isNormalUser = true;
    description = "Carlos Paludetto";
    extraGroups = [
      "adbusers"
      "greeter"
      "kvm"
      "networkmanager"
      "podman"
      "wheel"
    ];
  };

  # SSH server
  services.openssh.enable = true;

  # Podman
  virtualisation.containers.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.extraPackages = with pkgs; [ virtiofsd ];
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.dockerSocket.enable = true; # Mimic docker socket.
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.

  # ADB (Android Device Bridge)
  programs.adb.enable = true;

  # Enable ZSH
  programs.zsh.enable = true;

  # Enable nix-ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Necessary for JAVA + AWT (in Esprinter)
    fontconfig
    freetype
    libgcc
    libx11
    libxext
    libxrender
    libxt
    xorg.libX11
    xorg.libxcb
    xorg.libXft
    xorg.libXi
    xorg.libXt
    xorg.libXTrap
    xorg.libXtst
  ];

  # Enable localsend
  programs.localsend.enable = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # Commands / tools
    bitwarden-cli
    gcc
    gnumake
    liquidctl
    lsof
    sbctl
    podman-compose

    # Programs (GTK)
    baobab
    celluloid
    file-roller
    gnome-calculator
    gnome-font-viewer
    loupe
    mission-center
    nautilus
    papers

    # Programs
    jetbrains.idea-ultimate
    slack

    # Nix related
    home-manager

    # Mise needed
    python2
    python313

    # Niri
    config.home-manager.users.carlos.home.pointerCursor.package
    xwayland-satellite-stable

    # Sops
    sops
    inputs.opsops.packages.${system.triple}.default
  ];

  # Home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = { inherit default inputs system; };
  home-manager.users.carlos = import ../home/${system.triple}.nix;

  # Trash support
  services.gvfs.enable = true;

  # Open in Alacritty
  programs.nautilus-open-any-terminal.enable = true;
  programs.nautilus-open-any-terminal.terminal = "alacritty";

  # Enable sushi (preview in nautilus)
  services.gnome.sushi.enable = true;

  # Fonts
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.serif = [ default.fonts.sans.name ];
  fonts.fontconfig.defaultFonts.sansSerif = [ default.fonts.sans.name ];
  fonts.fontconfig.defaultFonts.monospace = [ default.fonts.mono.name ];
  fonts.fontconfig.defaultFonts.emoji = [ default.fonts.emoji.name ];
  fonts.packages = default.fonts.packages;

  # Dank material shell greeter
  programs.dankMaterialShell.greeter.enable = true;
  programs.dankMaterialShell.greeter.configHome = config.home-manager.users.carlos.home.homeDirectory;
  programs.dankMaterialShell.greeter.compositor.name = "niri";
  programs.dankMaterialShell.greeter.compositor.customConfig =
    with config.home-manager.users.carlos.home; ''
      cursor { xcursor-theme "${pointerCursor.name}"; xcursor-size ${builtins.toString pointerCursor.size}; }
      environment { "DMS_RUN_GREETER" "1"; }
      gestures { hot-corners { off; }; }
      hotkey-overlay { skip-at-startup; }
      output "DP-2" { transform "normal"; position x=0 y=0; mode "2560x1440@165.0"; focus-at-startup; }
      output "HDMI-A-1" { transform "90"; position x=2560 y=-820; mode "2560x1440@144.0"; }
    '';

  # Gnome keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Dconf
  programs.dconf.enable = true;

  # OBS
  programs.obs-studio.enable = true;
  programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [
    wlrobs # Wayland capture
    obs-pipewire-audio-capture # Pipewire audio capture
    obs-vaapi # AMD hardware acceleration
  ];
}
