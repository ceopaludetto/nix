{ default, inputs, ... }:
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
  programs.nixcord.config.enabledThemes = [ "dank-discord.css" ];
  programs.nixcord.config.useQuickCss = true;
  programs.nixcord.quickCss = ''
    body {
    	--font: '${default.fonts.sans.name}';

    	/* Use discord default icon */
    	--custom-dms-icon: off;

    	/* Top bar height */
    	--top-bar-height: 16px;
    }
  '';
}
