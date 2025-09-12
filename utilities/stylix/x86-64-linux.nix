{ inputs, pkgs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./common.nix
  ];

  stylix.cursor.name = "Bibata-Modern-Classic";
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.size = 24;
}
