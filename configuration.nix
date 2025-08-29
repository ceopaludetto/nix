{
  inputs,
  lib,
  pkgs,
  ...
}: let
  monitors.content = builtins.readFile ./assets/monitors.xml;
  monitors.source = pkgs.writeText "monitors.xml" monitors.content;

  theme.name = "gruvbox-material-dark-medium";
  theme.scheme = "dark";
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.home-manager.nixosModules.home-manager
  ];

  # State version
  system.stateVersion = "24.11";

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Nix GC
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 30d";

  # Disable documentation
  documentation.nixos.enable = false;

  # Allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Secure boot
  boot.lanzaboote.enable = true;
  boot.lanzaboote.pkiBundle = "/var/lib/sbctl";
  boot.lanzaboote.settings.console-mode = "max";
  boot.lanzaboote.settings.default = "Atlas*";

  # Plymouth
  boot.plymouth.enable = true;

  # Silent boot
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.kernelParams = [
    # Prevent logging to show plymouth correctly
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];

  # Enable networking
  networking.hostName = "Carlos-PC";
  networking.networkmanager.enable = true;

  # Set your time zone.
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

  # Enable AMD GPU
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Force display mode (by using EDID fetched from linuxhw and video= kernel parameters)
  hardware.display.edid.linuxhw."DEL41D9_2022" = [
    "DEL41D9"
    "2022"
  ];
  hardware.display.edid.linuxhw."DEL41DA_2022" = [
    "DEL41DA"
    "2022"
  ];

  # Set both video= and EDID for the horizontal monitor
  hardware.display.outputs."DP-2".mode = "2560x1440@165";
  hardware.display.outputs."DP-2".edid = "DEL41D9_2022.bin";

  # Set both video= and EDID for the vertical monitor
  hardware.display.outputs."HDMI-A-1".mode = "2560x1440@144";
  hardware.display.outputs."HDMI-A-1".edid = "DEL41DA_2022.bin";

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Fix time in Windows
  time.hardwareClockInLocalTime = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.enable = lib.mkForce false; # Disable X11 server
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "intl";

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.carlos = {
    isNormalUser = true;
    description = "Carlos Paludetto";
    extraGroups = [
      "adbusers"
      "kvm"
      "podman"
      "networkmanager"
      "wheel"
    ];
  };

  # Podman
  virtualisation.containers.enable = true;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  # ADB (Android Device Bridge)
  programs.adb.enable = true;

  # Enable ZSH
  programs.zsh.enable = true;

  # Enable nix-ld
  programs.nix-ld.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Force Wayland
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # Commands / tools
    gcc
    gnumake
    jq
    lsof
    sbctl
    vim
    wget

    # Fly.io CLI
    flyctl

    # Podman
    dive
    podman-compose

    # Required for Rust
    pkg-config
    openssl

    # Programs
    android-studio
    resources

    # NixOS related
    alejandra
    home-manager
    nixd

    # Mise needed
    python313
  ];

  # Exclude some gnome applications
  environment.gnome.excludePackages = with pkgs; [
    decibels
    epiphany
    geary
    gnome-characters
    gnome-connections
    gnome-console
    gnome-disk-utility
    gnome-software
    gnome-system-monitor
    gnome-tour
    gnome-user-docs
    gnome-weather
    yelp
  ];

  # Home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = {inherit inputs monitors;};
  home-manager.users.carlos = import ./home.nix;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
  ];

  # Configure monitor in GDM (https://discourse.nixos.org/t/var-lib-gdm-config-equivalent/49118/11)
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${monitors.source}"
  ];

  # Stylix
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.name}.yaml";

  stylix.fonts.serif.name = "Open Sans";
  stylix.fonts.serif.package = pkgs.open-sans;

  stylix.fonts.sansSerif.name = "Open Sans";
  stylix.fonts.sansSerif.package = pkgs.open-sans;

  stylix.fonts.monospace.name = "MonaspiceNe Nerd Font";
  stylix.fonts.monospace.package = pkgs.nerd-fonts.monaspace;

  stylix.fonts.emoji.name = "Noto Color Emoji";
  stylix.fonts.emoji.package = pkgs.noto-fonts-emoji;

  stylix.cursor.name = "Bibata-Modern-Classic";
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.size = 24;

  stylix.icons.enable = true;
  stylix.icons.package = pkgs.tela-circle-icon-theme.override {colorVariants = ["yellow"];};
  stylix.icons.dark = "Tela-circle-yellow-dark";
  stylix.icons.light = "Tela-circle-yellow-light";

  stylix.image = ./assets/wallpaper.jpg;

  stylix.polarity = theme.scheme;
}
