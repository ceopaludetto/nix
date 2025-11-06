{ ... }:
{
  imports = [
    ./common.nix
  ];

  # Force wayland
  programs.spicetify.windowManagerPatch = true;
  programs.spicetify.wayland = true;
}
