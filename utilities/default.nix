{ pkgs, ... }:
rec {
  fonts.sans.name = "Roboto Condensed";
  fonts.sans.package = pkgs.roboto;

  fonts.mono.name = "MonaspiceNe Nerd Font";
  fonts.mono.package = pkgs.nerd-fonts.monaspace;

  fonts.emoji.name = "Noto Color Emoji";
  fonts.emoji.package = pkgs.noto-fonts-color-emoji;

  fonts.size = 12;

  fonts.packages = [
    fonts.sans.package
    fonts.mono.package
    fonts.emoji.package
  ];

  wallpaper = import ./wallpaper.nix {
    lib = pkgs.lib;
    inherit pkgs;
  };

  window.gap = 4;
  window.margin = window.gap * 2;
  window.radius = 12;

  window.marginList = builtins.genList (_: window.margin) 4;
  window.marginListInString = builtins.map builtins.toString window.marginList;
}
