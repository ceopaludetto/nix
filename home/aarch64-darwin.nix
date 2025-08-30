{pkgs, ...}: {
  imports = [
    ./common.nix
  ];

  home.packages = with pkgs; [
    # Programs
    iina
    the-unarchiver
    rectangle
    raycast
    betterdisplay
  ];

  # TODO: Fix Ghostty, Jetbrains Toolbox, Scroll Reverser, Podman, Xcode
}
