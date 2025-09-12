{ lib, osConfig, ... }:
{
  programs.zed-editor.enable = true;

  programs.zed-editor.extensions = [
    # Style
    "bearded-icon-theme"
    "vitesse-theme-refined"
    # NixOS
    "nix"
    # GraphQL
    "graphql"
  ];

  programs.zed-editor.userSettings = {
    # Vim
    vim_mode = true;
    vim.use_system_clipboard = "never";

    # Style
    theme = lib.mkForce "Vitesse Refined Dark";
    icon_theme = lib.mkForce "Bearded Icon Theme";

    buffer_font_size = lib.mkForce 14;
    ui_font_family = lib.mkForce osConfig.stylix.fonts.monospace.name;

    minimap.show = "always";
    wrap_guides = [
      80
      120
    ];

    # Telemetry
    telemetry.diagnostics = false;
    telemetry.metrics = false;

    # Tabs
    max_tabs = 10;
    tabs.file_icons = true;

    # Project panel
    project_panel.hide_root = true;
    project_panel.auto_fold_dirs = true;
    project_panel.indent_size = 20;

    # Use tabs instead of spaces
    hard_tabs = true;
    tab_size = 2;

    # Disable AI entirely
    disable_ai = true;
  };
}
