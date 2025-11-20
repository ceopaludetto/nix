{ ... }:
{
  imports = [
    ./common.nix
  ];

  programs.alacritty.settings.window.decorations = "None";
}
