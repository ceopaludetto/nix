{ ... }:
{
  # Ghostty configuration (automatically themed with catppuccin nix module)

  programs.ghostty.enable = true;
  programs.ghostty.enableZshIntegration = true;

  # Basic	settings
  programs.ghostty.settings.shell-integration-features = "no-cursor";
  programs.ghostty.settings.cursor-style = "underline";

  # Font
  programs.ghostty.settings.font-family = "MonaspiceNe Nerd Font";
  programs.ghostty.settings.font-size = 16;
}
