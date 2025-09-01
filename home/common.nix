{
  inputs,
  pkgs,
  system,
  ...
}:
{
  imports = [
    # Zen Browser
    inputs.zen-browser.homeModules.beta

    # Nixcord (discord)
    inputs.nixcord.homeModules.nixcord

    # Spicetify (spotify)
    inputs.spicetify-nix.homeManagerModules.spicetify

    # Catppuccin
    inputs.catppuccin.homeModules.catppuccin

    # Applications
    ../programs/ghostty/${system.triple}.nix
    ../programs/nixcord/${system.triple}.nix
    ../programs/spicetify/${system.triple}.nix
    ../programs/vscode/${system.triple}.nix
    ../programs/zen-browser/${system.triple}.nix
  ];

  # State version
  home.stateVersion = "24.11";

  # User configuration
  home.username = "carlos";

  # Path
  home.sessionVariables = {
    ANDROID_HOME = "$HOME/Android/Sdk";
  };
  home.sessionPath = [
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/tools"
  ];

  # Programs
  home.packages = with pkgs; [
    # CLIs
    awscli2
    bombardier
    fastfetch
    flyctl
    wget

    # Nix related
    nixfmt
    nixd

    # Programs
    yaak
  ];

  # Home manager manages itself
  programs.home-manager.enable = true;

  # Git
  programs.git.enable = true;
  programs.git.userName = "Carlos Paludetto";
  programs.git.userEmail = "ceo.paludetto@gmail.com";
  programs.git.extraConfig = {
    core.editor = "vim";
    init.defaultBranch = "main";
    push.autoSetupRemote = true;
  };

  # ZSH
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.autocd = true;

  programs.zsh.autosuggestion.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;

  programs.zsh.shellAliases = {
    cat = "bat";
    ll = "ls -l";
    # Find and Prune node_modules aliases
    find-node-modules = "find . -name \"node_modules\" -type d -prune | xargs du -chs";
    prune-node-modules = "find . -name \"node_modules\" -type d -prune -exec rm -rf '{}' +";
  };

  # Starship
  programs.starship.enable = true;
  programs.starship.settings = {
    add_newline = false;

    character.success_symbol = "[➜](bold green)";
    character.error_symbol = "[➜](bold red)";

    aws.disabled = true;

    bun.symbol = "";

    custom.git_email.style = "208";
    custom.git_email.command = "echo $(git config user.email)";
    custom.git_email.detect_folders = [ ".git" ];
    custom.git_email.symbol = "";
    custom.git_email.format = "with [$symbol $output]($style)";
    custom.git_email.ignore_timeout = true;
  };

  # Bat
  programs.bat.enable = true;

  # Mise
  programs.mise.enable = true;
  programs.mise.enableZshIntegration = true;

  # Catppuccin
  catppuccin.enable = true;
  catppuccin.accent = "lavender";
  catppuccin.flavor = "mocha";
}
