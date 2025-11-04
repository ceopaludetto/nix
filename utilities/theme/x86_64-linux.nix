{ default, pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  # Set wallpaper
  programs.matugen.config = {
    wallpaper.command = "hyprctl";
    wallpaper.arguments = [
      "hyprpaper"
      "wallpaper"
      ",${default.wallpaper.inPNG}"
    ];
  };

  # Run matugen
  system.activationScripts.run-matugen = ''
    ${pkgs.matugen}/bin/matugen image ${default.wallpaper.inPNG}
  '';

  # Fonts
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts.serif = [ default.fonts.sans.name ];
  fonts.fontconfig.defaultFonts.sansSerif = [ default.fonts.sans.name ];
  fonts.fontconfig.defaultFonts.monospace = [ default.fonts.mono.name ];
  fonts.fontconfig.defaultFonts.emoji = [ default.fonts.emoji.name ];

  fonts.packages = default.fonts.packages;
}
