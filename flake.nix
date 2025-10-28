{
  description = "ceopaludetto flake";

  inputs = {
    # Nix packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix darwin
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Lanzaboote (secure boot support)
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    # Zen browser
    zen-browser.url = "github:benjaminkitt/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    # Nixcord (discord)
    nixcord.url = "github:kaylorben/nixcord";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";

    # Spicetify (spotify)
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Homebrew installation
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-core.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-cask.flake = false;

    # Homebrew casks as nix packages
    brew-nix.url = "github:BatteredBunny/brew-nix";
    brew-nix.inputs.nix-darwin.follows = "nix-darwin";
    brew-nix.inputs.brew-api.follows = "brew-api";
    brew-nix.inputs.nixpkgs.follows = "nixpkgs";
    brew-api.url = "github:BatteredBunny/brew-api";
    brew-api.flake = false;

    # Stylix
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    # VSCode
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # Android
    android.url = "github:tadfisher/android-nixpkgs/stable";
    android.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      ...
    }:
    {
      # nixOS
      nixosConfigurations.default =
        let
          system.triple = "x86_64-linux";
          system.isDarwin = false;
          system.isLinux = true;
        in
        nixpkgs.lib.nixosSystem {
          system = system.triple;
          specialArgs = { inherit inputs system; };
          modules = [
            ./configuration.${system.triple}.nix
          ];
        };

      # macOS
      darwinConfigurations.default =
        let
          system.triple = "aarch64-darwin";
          system.isDarwin = true;
          system.isLinux = false;
        in
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit inputs system; };
          modules = [
            ./configuration.${system.triple}.nix
          ];
        };
    };
}
