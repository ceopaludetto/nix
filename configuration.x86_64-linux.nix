{
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
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

  # Add overlay for nix-vscode-extensions
  nixpkgs.overlays = [ inputs.nix-vscode-extensions.overlays.default ];

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

  # Enabling VM bridge
  networking.useDHCP = false;
  networking.bridges = {
    "br0".interfaces = [ "enp74s0" ];
  };

  # Creating bridge
  networking.interfaces.br0.name = "br0";
  networking.interfaces.br0.useDHCP = true;

  # Wired interface
  networking.interfaces.enp74s0.name = "enp74s0";
  networking.interfaces.enp74s0.useDHCP = true;

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

  # Disable X11 server
  services.xserver.enable = lib.mkForce false;

  # Enable hyprland
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  programs.hyprland.withUWSM = true;

  # Enable UWSM
  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors = {
    hyprland.prettyName = "Hyprland";
    hyprland.comment = "Hyprland compositor managed by UWSM";
    hyprland.binPath = "/run/current-system/sw/bin/Hyprland";
  };

  # Configure XDG Portal
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];

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
      "kvm"
      "libvirtd"
      "wheel"
    ];
  };

  # SSH
  programs.ssh.startAgent = true;
  services.openssh.enable = true;

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.vhostUserPackages = with pkgs; [ virtiofsd ];

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

  # Enable virtualisation manager
  programs.virt-manager.enable = true;

  # Environment variables
  environment.variables = {
    QT_QPA_PLATFORM = "wayland;xcb"; # Force Wayland, fallback to X11
  };
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

    # Qemu
    qemu
    qemu_kvm

    # Required for Rust
    pkg-config
    openssl

    # Programs
    jetbrains.idea-ultimate
    genymotion
    nautilus
    slack

    # Nix related
    home-manager

    # Mise needed
    python2
    python313

    # Hyprland
    hyprshot
    inputs.quickshell.packages.${system.triple}.default

    # QML development (for quickshell)
    kdePackages.qtdeclarative
  ];

  # Home manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.extraSpecialArgs = { inherit inputs system; };
  home-manager.users.carlos = import ./home/${system.triple}.nix;

  # Auto login user
  services.getty.autologinUser = "carlos";

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.monaspace
  ];
}
