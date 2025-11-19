{ lib, ... }:
{
  imports = [
    ./common.nix
  ];

  programs.ghostty.settings.window-theme = "ghostty";
  programs.ghostty.settings.window-decoration = "none";

  # Reduce the size a little in linux
  programs.ghostty.settings.font-size = lib.mkForce 12;

  # Keep open forever (for quick terminal opens in hyprland)
  programs.ghostty.settings.quit-after-last-window-closed = false;
}
