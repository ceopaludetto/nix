{ pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  stylix.cursor.name = "Bibata-Modern-Classic";
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.size = 24;

  stylix.icons.enable = true;
  stylix.icons.package = pkgs.tela-circle-icon-theme.override { colorVariants = [ "yellow" ]; };
  stylix.icons.dark = "Tela-circle-yellow-dark";
  stylix.icons.light = "Tela-circle-yellow-light";
}
