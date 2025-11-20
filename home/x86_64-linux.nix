{
  config,
  default,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix

    # Programs
    ../programs/niri/x86_64-linux.nix
    ../programs/material-shell/x86_64-linux.nix
  ];

  # Home directory
  home.homeDirectory = lib.mkForce /home/carlos;

  # XDG
  xdg.userDirs.enable = true;

  # GTK
  gtk.enable = true;
  gtk.colorScheme = "dark";

  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3-dark";

  gtk.font.name = default.fonts.sans.name;
  gtk.font.size = default.fonts.size;

  # Link dank shell to GTK
  xdg.configFile."gtk-4.0/gtk.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/gtk-4.0/dank-colors.css";
  xdg.configFile."gtk-3.0/gtk.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/gtk-3.0/dank-colors.css";

  gtk.iconTheme.package = pkgs.tela-circle-icon-theme.override { colorVariants = [ "black" ]; };
  gtk.iconTheme.name = "Tela-circle-black-dark";

  # Cursor
  home.pointerCursor.enable = true;
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.name = "Bibata-Modern-Classic";
  home.pointerCursor.package = pkgs.bibata-cursors;
  home.pointerCursor.size = 24;

  # Dconf settings
  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":";

  # QT
  qt.enable = true;
  qt.platformTheme.name = "gtk3";
}
