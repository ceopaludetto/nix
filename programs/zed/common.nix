{ default, lib, ... }:
{
  programs.zed-editor.enable = true;

  programs.zed-editor.extensions = [
    # Style
    "bearded-icon-theme"
    # NixOS
    "nix"
    # GraphQL
    "graphql"
    # Dart
    "dart"
    # TOML
    "toml"
    # Typst
    "typst"
    # SQL
    "sql"
    # Makefile
    "make"
    # Swift
    "swift"
  ];

  programs.zed-editor.userSettings = {
    # Vim
    vim_mode = true;
    vim.use_system_clipboard = "never";

    # Keybinds
    base_keymap = "VSCode";

    # Style
    theme = lib.mkForce "Matugen Dark";
    icon_theme = lib.mkForce "Bearded Icon Theme";

    buffer_font_size = default.fonts.size * 3.5 / 3;
    buffer_font_family = default.fonts.mono.name;

    ui_font_family = default.fonts.sans.name;
    ui_font_size = default.fonts.size * 4.5 / 3;

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

    # Typst
    lsp.tinymist.settings.exportPdf = "onSave";
  };

  programs.zed-editor.userKeymaps = [
    {
      context = "Editor && !menu";
      bindings = {
        "ctrl-c" = "editor::Copy";
        "ctrl-x" = "editor::Cut";
        "ctrl-v" = "editor::Paste";
        "ctrl-y" = "editor::Undo";
        "ctrl-f" = "buffer_search::Deploy";
        "ctrl-o" = "workspace::Open";
        "ctrl-s" = "workspace::Save";
        "ctrl-a" = "editor::SelectAll";
        "ctrl-b" = "workspace::ToggleLeftDock";
      };
    }
  ];
}
