{ inputs, ... }:
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

  services.vicinae.enable = true;
  services.vicinae.autoStart = true;

  services.vicinae.settings = {
    popToRootOnClose = true;

    window.csd = true;
    window.opacity = 0.9;

    theme.name = "gruvbox-dark";
    theme.iconTheme = "Tela-circle-purple-dark";
  };
}
