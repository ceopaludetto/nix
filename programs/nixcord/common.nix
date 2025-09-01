{ ... }:
{
  # Nixcord configuration (manually themed with midnight catppuccin mocha)

  programs.nixcord.enable = true;

  # Fake nitro
  programs.nixcord.config.plugins.fakeNitro.enable = true;

  # Read all notifications button
  programs.nixcord.config.plugins.readAllNotificationsButton.enable = true;

  # Relationship notifier
  programs.nixcord.config.plugins.relationshipNotifier.enable = true;

  # Theme
  programs.nixcord.config.themeLinks = [
    "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/themes/flavors/midnight-catppuccin-mocha.theme.css"
  ];
}
