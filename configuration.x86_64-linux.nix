{
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
let
  monitors.content = builtins.readFile ./assets/monitors.xml;
  monitors.source = pkgs.writeText "monitors.xml" monitors.content;
in
{
  imports = [
    # Hardware
    ./hardware-configuration.nix

    # Secure Boot
    inputs.lanzaboote.nixosModules.lanzaboote

    # Home Manager
    inputs.home-manager.nixosModules.home-manager

    # Stylix
    ./utilities/stylix/${system.triple}.nix
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

  # Nix auto optimise store
  nix.optimise.automatic = true;

  # Disable documentation
  documentation.nixos.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Add overlay for nix-vscode-extensions
  nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

  # Allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];

  # Bootloader
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

  # Enable dconf
  programs.dconf.enable = true;

  # Environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Force Wayland
    NIXOS_WAYLAND = "1"; # Force Wayland
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

    # Podman
    dive
    podman-compose

    # Required for Rust
    pkg-config
    openssl

    # Programs
    android-studio
    resources

    # Nix related
    home-manager

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

  home-manager.extraSpecialArgs = { inherit inputs monitors system; };
  home-manager.users.carlos = import ./home/${system.triple}.nix;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
  ];

  # Configure monitor in GDM (https://discourse.nixos.org/t/var-lib-gdm-config-equivalent/49118/11)
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${monitors.source}"
  ];
}
