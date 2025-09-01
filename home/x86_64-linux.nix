{
  lib,
  monitors,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
    ../utilities/gnome.nix
  ];

  # Home directory
  home.homeDirectory = lib.mkForce /home/carlos;

  # Gnome
  programs.gnome-shell.enable = true;
  programs.gnome-shell.extensions = with pkgs; [
    { package = gnomeExtensions.alphabetical-app-grid; }
    { package = gnomeExtensions.appindicator; }
    { package = gnomeExtensions.blur-my-shell; }
    { package = gnomeExtensions.hide-universal-access; }
    { package = gnomeExtensions.rounded-window-corners-reborn; }
    { package = gnomeExtensions.user-themes; }
  ];

  # GTK
  gtk.enable = true;

  gtk.theme.name = "Colloid-Purple-Dark-Catppuccin";
  gtk.theme.package = pkgs.colloid-gtk-theme.override {
    themeVariants = [ "purple" ];
    tweaks = [
      "catppuccin"
      "normal"
    ];
  };

  gtk.cursorTheme.name = "Bibata-Modern-Classic";
  gtk.cursorTheme.package = pkgs.bibata-cursors;

  # Monitors.xml configuration
  xdg.configFile."monitors.xml".force = true;
  xdg.configFile."monitors.xml".source = monitors.source;
}
