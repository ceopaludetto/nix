{
  description = "NixOS configuration";

  inputs = {
    # Nix packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix asahi
    nixos-asahi.url = "github:nix-community/nixos-apple-silicon";
    nixos-asahi.inputs.nixpkgs.follows = "nixpkgs";

    # Nix hardware
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Lanzaboote (secure boot support)
    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    # SOPS (secrets manager)
    sops.url = "github:Mic92/sops-nix";
    sops.inputs.nixpkgs.follows = "nixpkgs";
    opsops.url = "github:vst/opsops";
    opsops.inputs.nixpkgs.follows = "nixpkgs";

    # Niri
    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    # Zen browser
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    # Spicetify (spotify)
    spicetify.url = "github:Gerg-L/spicetify-nix";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";

    # Nixcord (discord)
    nixcord.url = "github:kaylorben/nixcord";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";

    # VSCode
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # Android
    android.url = "github:tadfisher/android-nixpkgs/stable";
    android.inputs.nixpkgs.follows = "nixpkgs";

    # Dank Material Shell
    dgop.url = "github:AvengeMedia/dgop";
    dgop.inputs.nixpkgs.follows = "nixpkgs";

    dms.url = "github:AvengeMedia/DankMaterialShell";
    dms.inputs.nixpkgs.follows = "nixpkgs";
    dms.inputs.dgop.follows = "dgop";
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    {
      # Desktop
      nixosConfigurations.desktop =
        let
          system.triple = "x86_64-linux";
          default = import ./utilities/default.nix {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system.triple};
          };
        in
        nixpkgs.lib.nixosSystem {
          system = system.triple;
          specialArgs = { inherit default inputs system; };
          modules = [
            ./configuration/${system.triple}.nix
          ];
        };

      # Notebook
      nixosConfigurations.notebook =
        let
          system.triple = "aarch64-linux";
          default = import ./utilities/default.nix {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system.triple};
          };
        in
        nixpkgs.lib.nixosSystem {
          system = system.triple;
          specialArgs = { inherit default inputs system; };
          modules = [
            ./configuration/${system.triple}.nix
          ];
        };
    };
}
