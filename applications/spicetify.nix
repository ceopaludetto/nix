{...}: {
  programs.spicetify.enable = true;

  programs.spicetify.windowManagerPatch = true;
  programs.spicetify.wayland = false;
}
