{
  config,
  default,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
let
  toHypr = name: settings: lib.strings.concatLines (builtins.map (el: "${name}=${el}") settings);
  edids = [
    (pkgs.runCommand "DEL41D9" { } ''
      mkdir -p $out/lib/firmware/edid
      cp ${./assets/firmware/DEL41D9-DP-2-2560-1440-165.bin} $out/lib/firmware/edid/DEL41D9.bin
    '')
    (pkgs.runCommand "DEL41DA" { } ''
      mkdir -p $out/lib/firmware/edid
      cp ${./assets/firmware/DEL41DA-HDMI-A-1-2560-1440-144.bin} $out/lib/firmware/edid/DEL41DA.bin
    '')
  ];
in
{
  imports = [
    # Hardware
    ./hardware-configuration.nix

    # NixOS Hardware
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-hidpi

    # Secure Boot
    inputs.lanzaboote.nixosModules.lanzaboote

    # Home Manager
    inputs.home-manager.nixosModules.home-manager

    # DMS greeter
    inputs.dms.nixosModules.greeter
  ];

  # State version
  system.stateVersion = "24.11";

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

  # Bootloader
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Secure boot
  boot.lanzaboote.enable = true;
  boot.lanzaboote.pkiBundle = "/var/lib/sbctl";
  boot.lanzaboote.settings.console-mode = "max";
  boot.lanzaboote.settings.default = "Atlas*";

  # Support NTFS
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable AMD GPU
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Force display mode (by using CRU modified EDID)
  hardware.display.edid.enable = true;
  hardware.display.edid.packages = edids;

  # Set both video= and EDID for the horizontal monitor
  hardware.display.outputs."DP-2".mode = "e";
  hardware.display.outputs."DP-2".edid = "DEL41D9.bin";

  # Set both video= and EDID for the vertical monitor
  hardware.display.outputs."HDMI-A-1".mode = "e";
  hardware.display.outputs."HDMI-A-1".edid = "DEL41DA.bin";

  # Enable networking
  networking.hostName = "Carlos-PC";
  networking.useDHCP = false;

  # Wifi interface
  networking.interfaces.wlp73s0.name = "wlp73s0";
  networking.interfaces.wlp73s0.useDHCP = true;

  # Wired interface
  networking.interfaces.enp74s0.name = "enp74s0";
  networking.interfaces.enp74s0.useDHCP = true;

  # Enable networkmanager
  networking.networkmanager.enable = true;
  networking.networkmanager.settings.device.keep-configuration = "no";
  networking.networkmanager.ensureProfiles.profiles = {
    WiFi = {
      connection.autoconnect = "false";
      connection.id = "WiFi";
      connection.timestamp = "1762314067";
      connection.type = "wifi";
      connection.uuid = "8ba21304-aa09-4752-86f5-c21ff6b55d54";

      ipv4.method = "auto";
      ipv6.addr-gen-mode = "default";
      ipv6.method = "auto";

      wifi.mode = "infrastructure";
      wifi.ssid = "Metallica";

      wifi-security.key-mgmt = "wpa-psk";
      wifi-security.psk = "ruacorreiabarbosa@#17";
    };
    Wired = {
      connection.autoconnect-priority = "-999";
      connection.id = "Wired";
      connection.interface-name = "enp74s0";
      connection.timestamp = "1762303218";
      connection.type = "ethernet";
      connection.uuid = "602146ae-6631-3235-abd6-21d435723583";

      ipv4.method = "auto";
      ipv6.addr-gen-mode = "default";
      ipv6.method = "auto";
    };
    Docker = {
      bridge.stp = "false";

      connection.autoconnect = "false";
      connection.id = "Docker";
      connection.interface-name = "docker0";
      connection.timestamp = "1762303222";
      connection.type = "bridge";
      connection.uuid = "ae6ce40c-1b0b-446b-bbe8-54a0bca7cf9c";

      ipv4.address1 = "172.17.0.1/16";
      ipv4.method = "manual";

      ipv6.addr-gen-mode = "default";
      ipv6.method = "ignore";
    };
    Loopback = {
      connection.autoconnect = "false";
      connection.id = "Loopback";
      connection.interface-name = "lo";
      connection.timestamp = "1762303218";
      connection.type = "loopback";
      connection.uuid = "7d53e1be-5e5f-424c-8032-86cab7ee19a6";

      ipv4.address1 = "127.0.0.1/8";
      ipv4.method = "manual";

      ipv6.addr-gen-mode = "default";
      ipv6.address1 = "::1/128";
      ipv6.method = "manual";
    };
  };

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

  # Enable hyprland
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  programs.hyprland.withUWSM = true;

  # Enable UWSM
  programs.uwsm.enable = true;
  programs.uwsm.package = pkgs.uwsm.override { uuctlSupport = false; };
  programs.uwsm.waylandCompositors = {
    hyprland.prettyName = "Hyprland";
    hyprland.comment = "Hyprland compositor managed by UWSM";
    hyprland.binPath = "/run/current-system/sw/bin/Hyprland";
  };

  # Configure XDG Portal
  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];

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
      "docker"
      "greeter"
      "kvm"
      "libvirtd"
      "networkmanager"
      "wheel"
    ];
  };

  # SSH server
  services.openssh.enable = true;

  # Docker
  virtualisation.containers.enable = true;
  virtualisation.docker.enable = true;

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
    xorg.libXtst
    xorg.libXi
    xorg.libXft
    xorg.libXTrap
    xorg.libXt
  ];

  # Enable localsend
  programs.localsend.enable = true;

  # Environment variables
  environment.variables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    NIXOS_OZONE_WL = "1"; # Force Wayland
    NIXOS_WAYLAND = "1"; # Force Wayland
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    QT_QPA_PLATFORM = "wayland"; # Force Wayland, fallback to X11
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # Commands / tools
    gcc
    gnumake
    hw-probe
    lsof
    sbctl

    # Qemu
    qemu
    qemu_kvm

    # Required for Rust
    pkg-config
    openssl

    # Programs (GTK)
    gnome-font-viewer
    gnome-calculator
    loupe
    nautilus
    papers

    # Programs
    jetbrains.idea-ultimate
    genymotion
    slack

    # Nix related
    home-manager

    # Mise needed
    python2
    python313

    # Hyprland
    config.home-manager.users.carlos.home.pointerCursor.package
    glib
    hyprshot
    kdePackages.qtmultimedia
    matugen
  ];

  # Home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = { inherit default inputs system; };
  home-manager.users.carlos = import ./home/${system.triple}.nix;

  # Trash support
  services.gvfs.enable = true;

  # Open in Ghostty
  programs.nautilus-open-any-terminal.enable = true;
  programs.nautilus-open-any-terminal.terminal = "ghostty";

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
  programs.dankMaterialShell.greeter.compositor.name = "hyprland";
  programs.dankMaterialShell.greeter.compositor.customConfig = ''
    env = DMS_RUN_GREETER,1

    exec-once=hyprctl setcursor ${config.home-manager.users.carlos.home.pointerCursor.name} ${builtins.toString config.home-manager.users.carlos.home.pointerCursor.size}
    misc {
     	disable_hyprland_logo = true
      disable_splash_rendering = true
    }

    ${toHypr "monitor" config.home-manager.users.carlos.wayland.windowManager.hyprland.settings.monitor}
  '';

  # Gnome keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
