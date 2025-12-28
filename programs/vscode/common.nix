{
  config,
  default,
  lib,
  pkgs,
  ...
}:
rec {
  # VScode configuration
  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode;

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
    jnoortheen.nix-ide
    mikestead.dotenv
    naumovs.color-highlight

    # Remote development
    ms-vscode-remote.remote-containers

    # Vim
    vscodevim.vim

    # Theme
    (pkgs.callPackage ./utilities/theme.nix {
      homeDirectory = toString config.home.homeDirectory;
    })
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
    "workbench.iconTheme" = lib.mkForce "bearded-icons";
    "workbench.colorTheme" = lib.mkForce "Dynamic Base16 DankShell";
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
    "window.titleBarStyle" = "native";
    "window.title" = "\${appName}\${separator}\${rootNameShort}";
    "window.commandCenter" = true;
    "window.dialogStyle" = "native";
    "window.newWindowDimensions" = "maximized";
    "window.zoomLevel" = 1;
    "window.menuBarVisibility" = "hidden";
    "window.customTitleBarVisibility" = "auto";

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
    "editor.inlayHints.enabled" = "offUnlessPressed";
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
    "terminal.integrated.stickyScroll.enabled" = false;

    # Telemetry
    "telemetry.telemetryLevel" = "off";

    "chat.disableAIFeatures" = true;

    # Font configuration
    "markdown.preview.fontSize" = default.fonts.size;
    "chat.editor.fontSize" = default.fonts.size;
    "debug.console.fontSize" = default.fonts.size;
    "editor.fontSize" = default.fonts.size;
    "terminal.integrated.fontSize" = default.fonts.size;

    # Nix configuration
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "nix.formatterPath" = "nixfmt";

    "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
    "[nix]"."editor.formatOnSave" = true;
  };

  # Rust
  programs.vscode.profiles."Rust".extensions =
    with pkgs.vscode-marketplace;
    [
      tamasfe.even-better-toml
      rust-lang.rust-analyzer
    ]
    ++ programs.vscode.profiles.default.extensions;

  programs.vscode.profiles."Rust".userSettings = programs.vscode.profiles.default.userSettings // {
    # Rust
    "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";
    "[rust]"."editor.formatOnSave" = true;

    # TOML
    "[toml]"."editor.defaultFormatter" = "tamasfe.even-better-toml";
    "[toml]"."editor.formatOnSave" = true;
  };

  # Swift
  programs.vscode.profiles."Swift".extensions =
    with pkgs.vscode-marketplace;
    [
      llvm-vs-code-extensions.lldb-dap
      swiftlang.swift-vscode
    ]
    ++ programs.vscode.profiles.default.extensions;

  programs.vscode.profiles."Swift".userSettings = programs.vscode.profiles.default.userSettings // {
    "[swift]"."editor.defaultFormatter" = "swiftlang.swift-vscode";
    "[swift]"."editor.formatOnSave" = true;
  };

  # Typescript
  programs.vscode.profiles."TypeScript".extensions =
    with pkgs.vscode-marketplace;
    [
      bradlc.vscode-tailwindcss
      dbaeumer.vscode-eslint
    ]
    ++ programs.vscode.profiles.default.extensions;

  programs.vscode.profiles."TypeScript".userSettings =
    programs.vscode.profiles.default.userSettings
    // {
      "javascript.updateImportsOnFileMove.enabled" = "never";
      "javascript.preferences.importModuleSpecifier" = "shortest";
      "javascript.preferences.importModuleSpecifierEnding" = "minimal";

      "typescript.updateImportsOnFileMove.enabled" = "never";
      "typescript.preferences.importModuleSpecifier" = "shortest";
      "typescript.preferences.importModuleSpecifierEnding" = "minimal";
    };

  # Dart
  programs.vscode.profiles."Dart".extensions =
    with pkgs.vscode-marketplace;
    [
      dart-code.dart-code
      dart-code.flutter
    ]
    ++ programs.vscode.profiles.default.extensions;

  programs.vscode.profiles."Dart".userSettings = programs.vscode.profiles.default.userSettings // {
    "[dart]"."editor.defaultFormatter" = "Dart-Code.flutter";
    "[dart]"."editor.formatOnSave" = true;
  };

  # Writing
  programs.vscode.profiles."Writing".extensions =
    with pkgs.vscode-marketplace;
    [
      myriad-dreamin.tinymist
    ]
    ++ programs.vscode.profiles.default.extensions;

  programs.vscode.profiles."Writing".userSettings = programs.vscode.profiles.default.userSettings // {
    "[typst]"."editor.defaultFormatter" = "myriad-dreamin.tinymist";
    "[typst]"."editor.formatOnSave" = true;
  };

  # Vue (based on TypeScript)
  programs.vscode.profiles."Vue".extensions =
    with pkgs.vscode-marketplace;
    [
      vue.volar
    ]
    ++ programs.vscode.profiles."TypeScript".extensions;

  programs.vscode.profiles."Vue".userSettings =
    programs.vscode.profiles."TypeScript".userSettings // { };
}
