{ config, ... }:
let
  theme.url = "https://raw.githubusercontent.com/refact0r/midnight-discord/refs/heads/master/themes/midnight.theme.css";
  theme.overrides = config.lib.stylix.colors {
    template = ../../assets/overrides/nixcord.css.mustache;
    extension = ".css";
  };
in
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
  programs.nixcord.config.themeLinks = [ theme.url ];

  programs.nixcord.config.useQuickCss = true;
  programs.nixcord.quickCss = builtins.readFile theme.overrides;

  stylix.targets.nixcord.enable = false;
}
