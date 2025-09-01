{ lib, ... }:
{
  imports = [
    ./common.nix
  ];

  programs.ghostty.settings.window-theme = "ghostty";
  programs.ghostty.settings.gtk-tabs-location = "hidden";
  programs.ghostty.settings.adw-toolbar-style = "flat";

  # Reduce the size a little in linux
  programs.ghostty.settings.font-size = lib.mkForce 12;
}
