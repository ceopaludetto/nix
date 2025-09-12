{ inputs, ... }:
{
  imports = [
    inputs.stylix.darwinModules.stylix
    ./common.nix
  ];
}
