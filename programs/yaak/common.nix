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
}
