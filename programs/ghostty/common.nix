{ default, osConfig, ... }:
{
  # Ghostty configuration (stylix supported)
  programs.ghostty.enable = true;
  programs.ghostty.enableZshIntegration = true;

  # Basic	settings
  programs.ghostty.settings.shell-integration-features = "no-cursor";
  programs.ghostty.settings.cursor-style = "underline";

  # Font settings
  programs.ghostty.settings.font-family = default.fonts.mono.name;

  # Theme
  programs.ghostty.settings.theme = "Matugen";
  xdg.configFile."ghostty/themes/Matugen".source =
    "${osConfig.programs.matugen.theme.files}/.config/ghostty/themes/Matugen";
}
