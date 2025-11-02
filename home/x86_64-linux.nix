{
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  imports = [
    ./common.nix
    ../programs/vicinae/x86_64-linux.nix
  ];

  # Home directory
  home.homeDirectory = lib.mkForce /home/carlos;

  # Home packages
  home.packages = with pkgs; [
    # Programs
    yaak

    # CLIs
    valgrind
  ];

  # Hyprland
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package = null;
  wayland.windowManager.hyprland.portalPackage = null;
  wayland.windowManager.hyprland.systemd.enable = false; # UWSM
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    general.gaps_in = 3;
    general.gaps_out = "0,6,6,6";
    general.border_size = 0;

    decoration.rounding = 8;
    decoration.inactive_opacity = 0.9;

    input.kb_layout = "us";
    input.kb_variant = "intl"; # Support dead keys
    input.follow_mouse = 2;

    windowrule = [
      "workspace 2, class:^(zen-beta)$" # Open Zen in workspace 2
      "workspace 6, class:^(Slack)$" # Open Slack in workspace 6

      "fullscreenstate:0 0, class:^(yaak-app)$" # Force yaak to open windowed
    ];

    layerrule = [
      # Vicinae
      "blur,vicinae"
      "ignorealpha 0, vicinae"
      "noanim, vicinae"
    ];

    workspace = [
      "1, persistent:true, monitor:DP-2"
      "2, persistent:true, monitor:DP-2"
      "3, persistent:true, monitor:DP-2"
      "4, persistent:true, monitor:DP-2"
      "5, persistent:true, monitor:DP-2"

      "6, persistent:true, monitor:HDMI-A-1"
      "7, persistent:true, monitor:HDMI-A-1"
      "8, persistent:true, monitor:HDMI-A-1"
      "9, persistent:true, monitor:HDMI-A-1"
      "10, persistent:true, monitor:HDMI-A-1"
    ];

    bind = [
      # Applications
      "$mod, T, exec, ghostty"
      "$mod, Space, exec, vicinae toggle"

      # Close active window
      "$mod, Q, killactive"

      # Cycle focus
      "$mod, h, movefocus, l"
      "$mod, l, movefocus, r"
      "$mod, k, movefocus, u"
      "$mod, j, movefocus, d"

      # Move window
      "$mod SHIFT, h, movewindow, l"
      "$mod SHIFT, l, movewindow, r"
      "$mod SHIFT, k, movewindow, u"
      "$mod SHIFT, j, movewindow, d"

      # Cycle through workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      # Move window to workspace
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      # Screenshot
      ", PRINT, exec, hyprshot -m output"
      "$mod, PRINT, exec, hyprshot -m window"
      "$mod SHIFT, PRINT, exec, hyprshot -m region"
    ];

    binde = [
      # Resize
      "ALT, h, resizeactive, -32 0" # 2560 / 80 = 32 (80 sections)
      "ALT, l, resizeactive, 32 0"
      "ALT, k, resizeactive, 0 -18" # 1440 / 80 = 18 (80 sections)
      "ALT, j, resizeactive, 0 18"
    ];

    monitor = [
      "HDMI-A-1, 2560x1440@1444, 2560x-820, 1, transform, 1"
      "DP-2, 2560x1440@165, 0x0, 1"
    ];

    exec-once = [
      "qs" # Start quickshell

      # Default open applications
      "[workspace 2 silent] zen-beta"
      "[workspace 6 silent] slack"
    ];
  };

  programs.zsh.profileExtra = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    	exec uwsm start -S hyprland-uwsm.desktop
    fi
  '';

  # Notifications
  services.mako.enable = true;

  # GTK
  gtk.enable = true;

  gtk.iconTheme.name = osConfig.stylix.icons.dark;
  gtk.iconTheme.package = osConfig.stylix.icons.package;

  # Dconf settings
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":";
}
