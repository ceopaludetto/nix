{ inputs, osConfig, ... }:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  # Nixcord configuration (manually themed with midnight catppuccin mocha)
  programs.nixcord.enable = true;

  # Fake nitro
  programs.nixcord.config.plugins.fakeNitro.enable = true;

  # Read all notifications button
  programs.nixcord.config.plugins.readAllNotificationsButton.enable = true;

  # Relationship notifier
  programs.nixcord.config.plugins.relationshipNotifier.enable = true;

  # Theme
  programs.nixcord.config.enabledThemes = [ "discord.css" ];
  xdg.configFile."vesktop/themes/discord.css".source =
    "${osConfig.programs.matugen.theme.files}/.config/vesktop/themes/discord.css";
}
