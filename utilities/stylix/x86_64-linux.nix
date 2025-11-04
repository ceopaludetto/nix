{ inputs, pkgs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./common.nix
  ];

  stylix.cursor.name = "Bibata-Modern-Classic";
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.size = 24;

  stylix.icons.enable = true;
  stylix.icons.package = pkgs.papirus-icon-theme.override { color = "palebrown"; };
  stylix.icons.dark = "Papirus-Dark";
  stylix.icons.light = "Papirus-Light";
}
