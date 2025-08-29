{...}: {
  programs.nixcord.enable = true;

  # Use vesktop instead of discord
  programs.nixcord.discord.enable = false;
  programs.nixcord.vesktop.enable = true;

  # Fake nitro
  programs.nixcord.config.plugins.fakeNitro.enable = true;

  # Read all notifications button
  programs.nixcord.config.plugins.readAllNotificationsButton.enable = true;

  # Relationship notifier
  programs.nixcord.config.plugins.relationshipNotifier.enable = true;

  # Remove title bar
  programs.nixcord.config.useQuickCss = true;
  programs.nixcord.quickCss = ''
    :root {
     	--custom-app-top-bar-height: 10px !important;
     }

     div[data-fullscreen] > div:first-child {
     	display: none!important;
     }
  '';
}
