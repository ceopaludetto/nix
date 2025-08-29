{
  lib,
  config,
  ...
}: {
  programs.zed-editor.enable = true;

  # Extensions
  programs.zed-editor.extensions = [
    "bearded-icon-theme"
    "color-highlight"
    "git-firefly"
    "graphql"
    "make"
    "nix"
    "xml"
  ];

  # Theme configuration
  programs.zed-editor.userSettings.icon_theme = "Bearded Icon Theme";
  programs.zed-editor.userSettings.ui_font_family = lib.mkForce config.stylix.fonts.monospace.name;
  programs.zed-editor.userSettings.buffer_font_size = lib.mkForce 14;

  # Use vim emulation
  programs.zed-editor.userSettings.vim_mode = true;
  programs.zed-editor.userSettings.vim.use_system_clipboard = "always";

  # Disable telemetry
  programs.zed-editor.userSettings.telemetry.metrics = false;
  programs.zed-editor.userSettings.telemetry.diagnostics = false;

  # Use tabs instead of spaces for indentation
  programs.zed-editor.userSettings.hard_tabs = true;
  programs.zed-editor.userSettings.tab_size = 2;

  # Tab bar
  programs.zed-editor.userSettings.max_tabs = 10;
  programs.zed-editor.userSettings.tabs.file_icons = true;

  # Minimap
  programs.zed-editor.userSettings.minimap.show = "always";

  # Wrap guides
  programs.zed-editor.userSettings.wrap_guides = [
    80
    120
  ];

  # Project panel
  programs.zed-editor.userSettings.project_panel.entry_spacing = "comfortable";
  programs.zed-editor.userSettings.project_panel.hide_root = true;
}
