{ pkgs, ... }:
{
  home.packages =
    let
      yaak = pkgs.yaak.overrideAttrs (super: {
        # Support GTK file chooser
        nativeBuildInputs = super.nativeBuildInputs ++ [ pkgs.wrapGAppsHook4 ];
      });
    in
    [ yaak ];

  xdg.desktopEntries."yaak".name = "Yaak";
  xdg.desktopEntries."yaak".icon = "yaak-app";
  xdg.desktopEntries."yaak".type = "Application";

  # Force xWayland
  xdg.desktopEntries."yaak".exec = "env -u WAYLAND_DISPLAY yaak-app";

  xdg.desktopEntries."yaak".terminal = false;
  xdg.desktopEntries."yaak".categories = [ "Development" ];

  xdg.desktopEntries."yaak".settings = {
    StartupWMClass = "yaak-app";
  };
}
