{
  config,
  inputs,
  pkgs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Spicetify configuration (manually themed with catppuccin mocha)

  programs.spicetify.enable = true;

  programs.spicetify.theme = spicePkgs.themes.catppuccin;
  programs.spicetify.colorScheme = config.catppuccin.flavor;

  programs.spicetify.enabledExtensions = with spicePkgs.extensions; [
    hidePodcasts
  ];
}
