{ default, ... }:
{
  # Alacritty configuration
  programs.alacritty.enable = true;

  # General settings
  programs.alacritty.settings.cursor.style.shape = "Underline";

  # Font settings
  programs.alacritty.settings.font.normal.family = default.fonts.mono.name;
  programs.alacritty.settings.font.size = default.fonts.size;

  # Theme
  programs.alacritty.settings.general.import = [
    (builtins.toString "./dank-theme.toml")
  ];
}
