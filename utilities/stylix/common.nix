{ lib, pkgs, ... }:
let
  theme.image = ../../assets/wallpaper.heic;
  theme.polarity = "dark";
in
{
  stylix.enable = true;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
  stylix.polarity = theme.polarity;

  stylix.fonts.serif.name = "Open Sans";
  stylix.fonts.serif.package = pkgs.open-sans;

  stylix.fonts.sansSerif.name = "Open Sans";
  stylix.fonts.sansSerif.package = pkgs.open-sans;

  stylix.fonts.monospace.name = "MonaspiceNe Nerd Font";
  stylix.fonts.monospace.package = pkgs.nerd-fonts.monaspace;

  stylix.fonts.emoji.name = "Noto Color Emoji";
  stylix.fonts.emoji.package = pkgs.noto-fonts-emoji;

  stylix.image = pkgs.runCommand "wallpaper.png" { } ''
    ${lib.getExe' pkgs.imagemagick "convert"} "${theme.image}" -compress lossless $out
  '';
}
