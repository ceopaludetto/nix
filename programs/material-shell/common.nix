{ inputs, ... }:
{
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
  ];

  programs.dankMaterialShell = {
    enable = true;
    enableSystemd = true;

    default.settings.theme = "dark";
    default.settings.dynamicTheming = true;
  };
}
