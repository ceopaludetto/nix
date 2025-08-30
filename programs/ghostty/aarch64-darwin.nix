{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
  ];

  # Use binary since its broken on macOS
  programs.ghostty.package = pkgs.ghostty-bin;

  programs.ghostty.settings.macos-titlebar-style = "tabs";
  programs.ghostty.settings.macos-titlebar-proxy-icon = "hidden";

  programs.ghostty.settings.font-size = lib.mkForce 16;
}
