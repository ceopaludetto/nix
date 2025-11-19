{ default, ... }:
{
  # Ghostty configuration (stylix supported)
  programs.ghostty.enable = true;
  programs.ghostty.enableZshIntegration = true;

  # Basic	settings
  programs.ghostty.settings.shell-integration-features = "no-cursor";
  programs.ghostty.settings.cursor-style = "underline";
  programs.ghostty.settings.app-notifications = "no-clipboard-copy,no-config-reload";

  # Font settings
  programs.ghostty.settings.font-family = default.fonts.mono.name;

  # Theme
  programs.ghostty.settings.config-file = builtins.toString "./config-dankcolors";
}
