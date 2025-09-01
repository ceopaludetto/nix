{ lib, pkgs, ... }:
let
  font.family = "MonaspiceNe Nerd Font";
  font.size = 13;
in
rec {
  # VScode configuration (automatically themed with catppuccin nix module)

  programs.vscode.enable = true;

  programs.vscode.profiles.default.enableUpdateCheck = false;
  programs.vscode.profiles.default.enableExtensionUpdateCheck = false;

  programs.vscode.profiles.default.extensions = with pkgs.vscode-marketplace; [
    # Style
    antfu.icons-carbon
    beardedbear.beardedicons
    usernamehw.errorlens
    # Common
    editorconfig.editorconfig
    graphql.vscode-graphql-syntax
    mikestead.dotenv
    naumovs.color-highlight
    # Vim
    vscodevim.vim
  ];

  programs.vscode.profiles.default.userSettings = {
    # Vim
    "vim.leader" = "<space>";
    "vim.camelCaseMotion.enable" = true;
    "vim.useSystemClipboard" = false;
    "vim.handleKeys" = {
      "<C-a>" = false;
      "<C-c>" = false;
      "<C-f>" = false;
      "<C-p>" = false;
      "<C-s>" = false;
      "<C-v>" = false;
      "<C-x>" = false;
      "<C-z>" = false;
    };

    # Security
    "security.workspace.trust.untrustedFiles" = "open";

    # Chat
    "chat.commandCenter.enabled" = false;

    # Workbench
    "workbench.productIconTheme" = "icons-carbon";
    "workbench.iconTheme" = "bearded-icons";
    "workbench.settings.editor" = "json";
    "workbench.startupEditor" = "none";
    "workbench.editor.limit.enabled" = true;
    "workbench.editor.limit.value" = 10;
    "workbench.tree.indent" = 20;
    "workbench.layoutControl.enabled" = false;

    # Explorer
    "explorer.confirmDragAndDrop" = false;
    "explorer.confirmDelete" = false;
    "explorer.confirmPasteNative" = false;

    # Window
    "window.titleBarStyle" = "custom";
    "window.title" = "\${appName}\${separator}\${rootNameShort}";
    "window.commandCenter" = true;
    "window.dialogStyle" = "native";
    "window.newWindowDimensions" = "maximized";
    "window.zoomLevel" = 1.15;

    # Error lens
    "errorLens.followCursor" = "activeLine";
    "errorLens.messageTemplate" = "$message ($source/$code)";
    "errorLens.messageBackgroundMode" = "message";
    "errorLens.padding" = "2px 4px";
    "errorLens.margin" = "1ch";

    "extensions.ignoreRecommendations" = true;

    # Editor
    "editor.acceptSuggestionOnEnter" = "on";
    "editor.codeActionsOnSave" = {
      "source.fixAll" = "explicit";
    };
    "editor.cursorBlinking" = "solid";
    "editor.cursorSmoothCaretAnimation" = "on";
    "editor.defaultColorDecorators" = "auto";
    "editor.fontLigatures" = true;
    "editor.inlineSuggest.enabled" = true;
    "editor.insertSpaces" = false;
    "editor.minimap.renderCharacters" = false;
    "editor.rulers" = [
      80
      120
    ];
    "editor.suggest.selectionMode" = "always";
    "editor.tabSize" = 2;
    "editor.stickyScroll.enabled" = false;
    "editor.quickSuggestions" = {
      "strings" = "on";
    };
    "editor.bracketPairColorization.enabled" = false;

    # Debug
    "debug.toolBarLocation" = "commandCenter";

    # Breadcrumbs
    "breadcrumbs.enabled" = false;

    # Terminal
    "terminal.integrated.cursorBlinking" = false;
    "terminal.integrated.cursorStyle" = "underline";
    "terminal.integrated.enableMultiLinePasteWarning" = "never";
    "terminal.integrated.tabs.enabled" = false;

    # Telemetry
    "telemetry.telemetryLevel" = "off";

    # Font configuration
    "markdown.preview.fontSize" = font.size;

    "chat.editor.fontSize" = font.size;
    "chat.editor.fontFamily" = font.family;

    "debug.console.fontSize" = font.size;
    "debug.console.fontFamily" = font.family;

    "editor.fontSize" = font.size;
    "editor.fontFamily" = font.family;

    "terminal.integrated.fontSize" = font.size;
    "terminal.integrated.fontFamily" = font.family;
  };

  # Rust
  programs.vscode.profiles."Rust".extensions =
    with pkgs.vscode-marketplace;
    [
      tamasfe.even-better-toml
      rust-lang.rust-analyzer
    ]
    ++ programs.vscode.profiles.default.extensions;

  programs.vscode.profiles."Rust".userSettings = lib.mkMerge [
    programs.vscode.profiles.default.userSettings
    {
      # Rust
      "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";
      "[rust]"."editor.formatOnSave" = true;

      # TOML
      "[toml]"."editor.defaultFormatter" = "tamasfe.even-better-toml";
      "[toml]"."editor.formatOnSave" = true;
    }
  ];

  # Typescript
  programs.vscode.profiles."TypeScript".extensions =
    with pkgs.vscode-marketplace;
    [
      dbaeumer.vscode-eslint
    ]
    ++ programs.vscode.profiles.default.extensions;

  programs.vscode.profiles."TypeScript".userSettings = lib.mkMerge [
    programs.vscode.profiles.default.userSettings
    {
      "javascript.updateImportsOnFileMove.enabled" = "never";
      "javascript.preferences.importModuleSpecifier" = "shortest";
      "javascript.preferences.importModuleSpecifierEnding" = "minimal";

      "typescript.updateImportsOnFileMove.enabled" = "never";
      "typescript.preferences.importModuleSpecifier" = "shortest";
      "typescript.preferences.importModuleSpecifierEnding" = "minimal";
    }
  ];

  # Nix
  programs.vscode.profiles."Nix".extensions =
    with pkgs.vscode-marketplace;
    [
      jnoortheen.nix-ide
    ]
    ++ programs.vscode.profiles.default.extensions;

  programs.vscode.profiles."Nix".userSettings = lib.mkMerge [
    programs.vscode.profiles.default.userSettings
    {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.formatterPath" = "nixfmt";

      "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
      "[nix]"."editor.formatOnSave" = true;
    }
  ];

  # Enable catppuccin for every profile
  catppuccin.vscode.profiles = lib.attrsets.mapAttrs (name: value: {
    settings.workbenchMode = "minimal";
    settings.extraBordersEnabled = true;

    # Disable icons
    icons.enable = false;
  }) programs.vscode.profiles;
}
