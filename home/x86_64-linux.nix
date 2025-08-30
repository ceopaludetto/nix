{
  monitors,
  osConfig,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
    ../utilities/gnome.nix
  ];

  # Home directory
  home.homeDirectory = /home/carlos;

  # Gnome
  programs.gnome-shell.enable = true;
  programs.gnome-shell.extensions = with pkgs; [
    { package = gnomeExtensions.alphabetical-app-grid; }
    { package = gnomeExtensions.appindicator; }
    { package = gnomeExtensions.blur-my-shell; }
    { package = gnomeExtensions.hide-universal-access; }
    { package = gnomeExtensions.rounded-window-corners-reborn; }
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
