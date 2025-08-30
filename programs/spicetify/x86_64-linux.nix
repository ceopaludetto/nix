{...}: {
  imports = [
    ./common.nix
  ];

  # Force xWayland
  programs.spicetify.windowManagerPatch = true;
  programs.spicetify.wayland = false;
}
