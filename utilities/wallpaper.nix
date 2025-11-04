{ lib, pkgs, ... }:
rec {
  image = ../assets/wallpaper.heic;
  inPNG = pkgs.runCommand "wallpaper.png" { } ''
    ${lib.getExe' pkgs.imagemagick "convert"} "${image}" -compress lossless $out
  '';
}
