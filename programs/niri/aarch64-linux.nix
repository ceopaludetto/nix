{ config, ... }:
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

    binds = with config.lib.niri.actions; {
      # Screen brightness
      "XF86MonBrightnessUp".action =
        spawn "dms" "ipc" "call" "brightness" "increment" "5"
          "backlight:apple-panel-bl";
      "XF86MonBrightnessDown".action =
        spawn "dms" "ipc" "call" "brightness" "decrement" "5"
          "backlight:apple-panel-bl";

      # Keyboard brightness
      "Alt+XF86MonBrightnessUp".action =
        spawn "dms" "ipc" "call" "brightness" "increment" "5"
          "leds:kbd_backlight";
      "Alt+XF86MonBrightnessDown".action =
        spawn "dms" "ipc" "call" "brightness" "decrement" "5"
          "leds:kbd_backlight";
    };
  };
}
