{ default, pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  # Set wallpaper
  programs.matugen.config = {
    wallpaper.command = "/usr/bin/osascript";
    wallpaper.arguments = [
      "-e"
      "tell application \"Finder\" to set desktop picture to POSIX file \"${default.wallpaper.image}\""
    ];
  };

  # Run matugen
  system.activationScripts.run-matugen.text = ''
    ${pkgs.matugen}/bin/matugen image ${default.wallpaper.inPNG}
  '';
}
