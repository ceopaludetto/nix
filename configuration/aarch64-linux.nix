{ config, inputs, ... }:
{
  imports = [
    # Common configuration
    ./common.nix
    # Hardware
    ../utilities/hardware/aarch64-linux.nix

    # NixOS Asahi
    inputs.nixos-asahi.nixosModules.default
  ];

  # State version
  system.stateVersion = "25.11";

  # Nix settings
  nix.settings.extra-substituters = [ "https://nixos-apple-silicon.cachix.org" ];
  nix.settings.extra-trusted-public-keys = [
    "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # Enable networking
  networking.hostName = "Carlos-Notebook";
  networking.useDHCP = false;

  # WiFi interface
  networking.interfaces.wlp1s0f0.name = "wlp1s0f0";
  networking.interfaces.wlp1s0f0.useDHCP = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.settings.device.keep-configuration = "no";

  # Enable networkmanager
  networking.networkmanager.ensureProfiles.environmentFiles = with config.sops; [
    secrets."wifi/password".path
  ];

  networking.networkmanager.ensureProfiles.profiles = {
    WiFi = {
      connection.autoconnect = "true";
      connection.id = "WiFi";
      connection.timestamp = "1762314067";
      connection.type = "wifi";
      connection.uuid = "24c8982b-7f6d-49a2-be1b-9c8763485b19";

      ipv4.method = "auto";
      ipv6.addr-gen-mode = "default";
      ipv6.method = "auto";

      wifi.mode = "infrastructure";
      wifi.ssid = "Metallica";

      wifi-security.key-mgmt = "wpa-psk";
      wifi-security.psk = "$METALLICA_PASSWORD";
    };
  };

  # Asahi configuration
  hardware.asahi.enable = true;
  hardware.asahi.peripheralFirmwareDirectory = ../assets/firmware/asahi;

  # Battery information
  services.upower.enable = true;
}
