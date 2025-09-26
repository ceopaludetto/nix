{ lib, pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    # CLIs
    dive
    podman
    podman-compose
  ];

  # Add Homebrew binaries to PATH
  programs.zsh.initContent =
    let
      script = lib.mkOrder 1000 "eval \"$(/opt/homebrew/bin/brew shellenv)\"";
    in
    lib.mkMerge [
      script
    ];
}
