{ ... }:
{
  imports = [
    ./common.nix
  ];

  programs.niri.settings.debug.render-drm-device = "/dev/dri/renderD128";
  programs.niri.settings = {
    input.touchpad.dwt = true;
    input.touchpad.disabled-on-external-mouse = true;

    # BuiltIn Monitor
    outputs."eDP-1".enable = true;
    outputs."eDP-1".mode.width = 3456;
    outputs."eDP-1".mode.height = 2160;
    outputs."eDP-1".mode.refresh = 60.0;
    outputs."eDP-1".position.x = 0;
    outputs."eDP-1".position.y = 0;
    outputs."eDP-1".focus-at-startup = true;
  };
}
