{ ... }:
{
  imports = [
    ./common.nix
  ];

  programs.niri.settings = {
    # Horizontal monitor
    outputs."DP-2".enable = true;
    outputs."DP-2".mode.width = 2560;
    outputs."DP-2".mode.height = 1440;
    outputs."DP-2".mode.refresh = 165.0;
    outputs."DP-2".position.x = 0;
    outputs."DP-2".position.y = 0;
    outputs."DP-2".focus-at-startup = true;

    # Vertical monitor
    outputs."HDMI-A-1".enable = true;
    outputs."HDMI-A-1".mode.width = 2560;
    outputs."HDMI-A-1".mode.height = 1440;
    outputs."HDMI-A-1".mode.refresh = 144.0;
    outputs."HDMI-A-1".position.x = 2560;
    outputs."HDMI-A-1".position.y = -820;
    outputs."HDMI-A-1".transform.rotation = 90;
  };
}
