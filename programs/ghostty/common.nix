{...}: {
  programs.ghostty.enable = true;
  programs.ghostty.enableZshIntegration = true;

  # Basic	settings
  programs.ghostty.settings.shell-integration-features = "no-cursor";
  programs.ghostty.settings.cursor-style = "underline";
}
