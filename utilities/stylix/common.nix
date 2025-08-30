{pkgs, ...}: let
  theme.name = "gruvbox-material-dark-medium";
  theme.scheme = "dark";
in {
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme.name}.yaml";

  stylix.fonts.serif.name = "Open Sans";
  stylix.fonts.serif.package = pkgs.open-sans;

  stylix.fonts.sansSerif.name = "Open Sans";
  stylix.fonts.sansSerif.package = pkgs.open-sans;

  stylix.fonts.monospace.name = "MonaspiceNe Nerd Font";
  stylix.fonts.monospace.package = pkgs.nerd-fonts.monaspace;

  stylix.fonts.emoji.name = "Noto Color Emoji";
  stylix.fonts.emoji.package = pkgs.noto-fonts-emoji;

  stylix.image = ../../assets/wallpaper.jpg;
  stylix.polarity = theme.scheme;
}
