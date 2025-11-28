{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    inputs.spicetify.homeManagerModules.default
  ];

  # Spicetify configuration
  programs.spicetify.enable = true;

  programs.spicetify.theme = spicePkgs.themes.comfy;
  programs.spicetify.colorScheme = "Spotify";

  programs.spicetify.enabledExtensions = with spicePkgs.extensions; [
    hidePodcasts
  ];

  # Force wayland
  programs.spicetify.windowManagerPatch = true;
  programs.spicetify.wayland = true;
}
