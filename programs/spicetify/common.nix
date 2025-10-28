{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Spicetify configuration (stylix supported)
  programs.spicetify.enable = true;

  programs.spicetify.theme = spicePkgs.themes.comfy;
  programs.spicetify.colorScheme = "Spotify";

  programs.spicetify.enabledExtensions = with spicePkgs.extensions; [
    hidePodcasts
  ];

  stylix.targets.spicetify.enable = false;
}
