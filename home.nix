{
  inputs,
  monitors,
  osConfig,
  pkgs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.nixcord.homeModules.nixcord
    inputs.spicetify-nix.homeManagerModules.spicetify

    ./applications/ghostty.nix
    ./applications/nixcord.nix
    ./applications/spicetify.nix
    ./applications/vscode.nix
    # ./applications/zed-editor.nix
    ./applications/zen-browser.nix

    ./utilities/dconf.nix
  ];

  # User configuration
  home.username = "carlos";
  home.homeDirectory = "/home/carlos";

  # State version
  home.stateVersion = "24.11";

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
    fastfetch
    stremio
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
  programs.zsh.autosuggestion.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.shellAliases = {
    cat = "bat";
    ll = "ls -l";
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
    custom.git_email.detect_folders = [".git"];
    custom.git_email.symbol = "";
    custom.git_email.format = "with [$symbol $output]($style)";
    custom.git_email.ignore_timeout = true;
  };

  # Bat
  programs.bat.enable = true;

  # Mise
  programs.mise.enable = true;
  programs.mise.enableZshIntegration = true;

  # Gnome
  programs.gnome-shell.enable = true;
  programs.gnome-shell.extensions = with pkgs; [
    {package = gnomeExtensions.alphabetical-app-grid;}
    {package = gnomeExtensions.appindicator;}
    {package = gnomeExtensions.blur-my-shell;}
    {package = gnomeExtensions.hide-universal-access;}
    {package = gnomeExtensions.rounded-window-corners-reborn;}
  ];

  # GTK
  gtk.enable = true;

  # For some reason stylix does not apply icons to home manager GTK
  gtk.iconTheme.name = osConfig.stylix.icons.dark;
  gtk.iconTheme.package = osConfig.stylix.icons.package;

  # Monitors.xml configuration
  xdg.configFile."monitors.xml".force = true;
  xdg.configFile."monitors.xml".source = monitors.source;
}
