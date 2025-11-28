{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  edids = [
    (pkgs.runCommand "DEL41D9" { } ''
      mkdir -p $out/lib/firmware/edid
      cp ${../assets/firmware/DEL41D9-DP-2-2560-1440-165.bin} $out/lib/firmware/edid/DEL41D9.bin
    '')
    (pkgs.runCommand "DEL41DA" { } ''
      mkdir -p $out/lib/firmware/edid
      cp ${../assets/firmware/DEL41DA-HDMI-A-1-2560-1440-144.bin} $out/lib/firmware/edid/DEL41DA.bin
    '')
  ];
in
{
  imports = [
    # Common configuration
    ./common.nix

    # Hardware
    ../utilities/hardware/x86_64-linux.nix

    # NixOS Hardware
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-hidpi

    # Secure Boot
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # State version
  system.stateVersion = "24.11";

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

  networking.networkmanager.ensureProfiles.environmentFiles = with config.sops; [
    secrets."wifi/password".path
  ];

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
      wifi-security.psk = "$METALLICA_PASSWORD";
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

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.variant = "intl";

  # Configure console keymap
  console.keyMap = "us-acentos";
}
