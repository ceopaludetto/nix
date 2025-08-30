{...}: {
  imports = [
    ./common.nix
  ];

  # Use Vesktop instead of Discord
  programs.nixcord.discord.enable = false;
  programs.nixcord.vesktop.enable = true;

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
