{ config, default, ... }:
let
  # Amount of sections in a window
  window.sections = 16.0;
  window.portion = resolution: (resolution / window.sections) / resolution * 100;

  spawn-uwsm = argv: spawn-uwsm-args ++ argv;
  spawn-uwsm-args = [
    "env"
    "GTK_USE_PORTAL=1"
    "uwsm"
    "app"
    "--"
  ];
in
{
  programs.niri.settings = {
    # Input configuration
    input.keyboard.xkb.layout = "us";
    input.keyboard.xkb.variant = "intl";
    input.keyboard.repeat-delay = 400;
    input.keyboard.repeat-rate = 35;

    # Misc
    gestures.hot-corners.enable = false;
    hotkey-overlay.skip-at-startup = true;
    xwayland-satellite.enable = true;
    prefer-no-csd = true;

    # Layout configuration
    layout.gaps = default.window.gap;
    layout.focus-ring.enable = false;
    layout.background-color = "transparent";
    layout.default-column-width.proportion = 1.0; # 100%

    # Overview
    overview.zoom = 0.6;
    overview.workspace-shadow.enable = false;

    # Spawn at startup
    spawn-at-startup = [
      { argv = spawn-uwsm [ "slack" ]; }
      { argv = spawn-uwsm [ "zen-beta" ]; }
    ];

    # Binds
    binds = with config.lib.niri.actions; {
      # Overview
      "Mod+Tab".action = toggle-overview;
      "Mod+Tab".hotkey-overlay.title = "Toggle Overview";

      # Cycle through workspace
      "Mod+1".action = focus-workspace 1;
      "Mod+2".action = focus-workspace 2;
      "Mod+3".action = focus-workspace 3;
      "Mod+4".action = focus-workspace 4;
      "Mod+5".action = focus-workspace 5;
      "Mod+6".action = focus-workspace 6;
      "Mod+7".action = focus-workspace 7;
      "Mod+8".action = focus-workspace 8;
      "Mod+9".action = focus-workspace 9;
      "Mod+0".action = focus-workspace 10;

      # Cycle with mouse
      "Mod+WheelScrollDown".action = focus-workspace-down;
      "Mod+WheelScrollUp".action = focus-workspace-up;
      "Mod+Shift+WheelScrollDown".action = focus-column-right;
      "Mod+Shift+WheelScrollUp".action = focus-column-left;

      # Cycle with keyboard
      "Mod+H".action = focus-column-left;
      "Mod+L".action = focus-column-right;
      "Mod+K".action = focus-workspace-up;
      "Mod+J".action = focus-workspace-down;

      # Move
      "Mod+Shift+H".action = move-column-left;
      "Mod+Shift+L".action = move-column-right;
      "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
      "Mod+Shift+J".action = move-window-down-or-to-workspace-down;

      # Resize (inc and dec 80 pixels per activation)
      "Alt+H".action = set-column-width "-${builtins.toString (window.portion 2560.0)}%";
      "Alt+L".action = set-column-width "+${builtins.toString (window.portion 2560.0)}%";

      # Volume control
      "XF86AudioRaiseVolume".action = spawn "dms" "ipc" "call" "audio" "increment" "5";
      "XF86AudioLowerVolume".action = spawn "dms" "ipc" "call" "audio" "decrement" "5";
      "XF86AudioMute".action = spawn "dms" "ipc" "call" "audio" "mute";

      # Media control
      "XF86AudioNext".action = spawn "dms" "ipc" "call" "mpris" "next";
      "XF86AudioPrev".action = spawn "dms" "ipc" "call" "mpris" "previous";
      "XF86AudioPlay".action = spawn "dms" "ipc" "call" "mpris" "playPause";

      # DMS misc
      "Mod+Space".action = spawn "dms" "ipc" "call" "spotlight" "toggle";
      "Mod+Slash".action = spawn "dms" "ipc" "call" "keybinds" "toggle" "niri";

      # Screenshot (both PrtScreen and S supported)
      "Print".action = spawn "dms" "ipc" "call" "niri" "screenshotWindow";
      "Mod+Print".action = spawn "dms" "ipc" "call" "niri" "screenshotScreen";
      "Mod+S".action = spawn "dms" "ipc" "call" "niri" "screenshotScreen";
      "Mod+Shift+Print".action = spawn "dms" "ipc" "call" "niri" "screenshot";
      "Mod+Shift+S".action = spawn "dms" "ipc" "call" "niri" "screenshot";

      # Applications
      "Mod+Q".action = close-window;
      "Mod+Q".hotkey-overlay.title = "Close Window";

      "Mod+T".action = spawn "alacritty";
      "Mod+T".hotkey-overlay.title = "Open Alacritty";
    };

    # Layer rules
    layer-rules = [
      # DMS rule
      {
        matches = [ { namespace = "^quickshell$"; } ];
        place-within-backdrop = true;
      }
      # Hide notifications from screencasting
      {
        matches = [ { namespace = "^dms:notification-popup$"; } ];
        block-out-from = "screencast";
      }
    ];

    # Window rules
    window-rules = [
      # Set border radius of all windows
      {
        clip-to-geometry = true;
        geometry-corner-radius.bottom-left = default.window.radius;
        geometry-corner-radius.bottom-right = default.window.radius;
        geometry-corner-radius.top-left = default.window.radius;
        geometry-corner-radius.top-right = default.window.radius;
        draw-border-with-background = false;
      }
      # Change opacity of inactive windows to 0.9
      {
        matches = [
          { is-active = false; }
        ];
        opacity = 0.9;
      }
      # Make some applications to open as 75% of the screen
      {
        matches = [
          { app-id = "^Alacritty$"; }
        ];
        default-column-width.proportion = 0.5;
      }
      # Make some applications to open floating
      {
        matches = [
          { app-id = "^org\\.gnome\\.Calculator$"; }
        ];
        open-floating = true;
      }
      # Make some applications to open on second monitor on startup
      {
        matches = [
          {
            app-id = "^Slack$";
            at-startup = true;
          }
        ];
        open-on-output = "HDMI-A-1";
      }
    ];

    # Lock on lid close
    switch-events.lid-close.action.spawn = [
      "dms"
      "ipc"
      "call"
      "lock"
      "lock"
    ];

    # Environment variables
    environment = {
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      NIXOS_OZONE_WL = "1";
      NIXOS_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
      XDG_CURRENT_DESKTOP = "niri";
    };
  };
}
