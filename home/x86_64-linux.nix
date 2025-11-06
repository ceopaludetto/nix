{
  config,
  default,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix

    # Material Shell
    ../programs/material-shell/x86_64-linux.nix
  ];

  # Home directory
  home.homeDirectory = lib.mkForce /home/carlos;

  # Hyprland
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.package = null;
  wayland.windowManager.hyprland.portalPackage = null;
  wayland.windowManager.hyprland.systemd.enable = false; # UWSM
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    general.gaps_in = default.window.gap;
    general.gaps_out = lib.strings.concatStringsSep "," default.window.marginListInString;
    general.border_size = 0;

    decoration.rounding = default.window.radius;
    decoration.inactive_opacity = 0.9;

    input.kb_layout = "us";
    input.kb_variant = "intl"; # Support dead keys
    input.follow_mouse = 2;

    misc.disable_hyprland_logo = true;
    misc.disable_splash_rendering = true;

    animations = {
      enabled = true;

      # Curves
      bezier = [
        "expressiveFastSpatial, 0.42, 1.67, 0.21, 0.90"
        "expressiveSlowSpatial, 0.39, 1.29, 0.35, 0.98"
        "expressiveDefaultSpatial, 0.38, 1.21, 0.22, 1.00"
        "emphasizedDecel, 0.05, 0.7, 0.1, 1"
        "emphasizedAccel, 0.3, 0, 0.8, 0.15"
        "standardDecel, 0, 0, 0, 1"
        "menuDecel, 0.1, 1, 0, 1"
        "menuAccel, 0.52, 0.03, 0.72, 0.08"
      ];

      # Animations
      animation = [
        "windowsIn, 1, 3, emphasizedDecel, popin 80%"
        "windowsOut, 1, 2, emphasizedDecel, popin 90%"
        "windowsMove, 1, 3, emphasizedDecel, slide"
        "border, 1, 10, emphasizedDecel"

        "layersIn, 1, 2.7, emphasizedDecel, popin 93%"
        "layersOut, 1, 2.4, menuAccel, popin 94%"

        "fadeLayersIn, 1, 0.5, menuDecel"
        "fadeLayersOut, 1, 2.7, menuAccel"

        "workspaces, 1, 7, menuDecel, slide"
      ];
    };

    windowrule = [
      "workspace 1, class:^(zen-beta)$" # Open Zen in workspace 1
      "workspace 6, class:^(Slack)$" # Open Slack in workspace 6

      "noborder, class:^(org\\.gnome\\.)"
      "noborder, class:^(com\\.mitchellh\\.ghostty)$"

      "float, class:^(org\\.gnome\\.Calculator)$"
      "float, class:^(yaak-app)$"
    ];

    layerrule = [
      "noanim, ^(quickshell)$"
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

      # Dank material shell
      "$mod, space, exec, dms ipc call spotlight toggle"
      "$mod, TAB, exec, dms ipc call hypr toggleOverview"

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

    # <el> repeat/locked
    bindel = [
      # +- audio
      ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 3"
      ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 3"
    ];

    # <l> locked
    bindl = [
      # Mute toggle
      ", XF86AudioMute, exec, dms ipc call audio mute"

      # Previous/Next/PlayPause
      ", XF86AudioNext, exec, dms ipc call mpris next"
      ", XF86AudioPrev, exec, dms ipc call mpris previous"
      ", XF86AudioPlay, exec, dms ipc call mpris playPause"
    ];

    # <e> repeat
    binde = [
      # Resize
      "ALT, h, resizeactive, -32 0" # 2560 / 80 = 32 (80 sections)
      "ALT, l, resizeactive, 32 0"
      "ALT, k, resizeactive, 0 -18" # 1440 / 80 = 18 (80 sections)
      "ALT, j, resizeactive, 0 18"
    ];

    # <c> click
    bindc = [
      "ALT, mouse:272, togglefloating"
    ];

    # <m> mouse
    bindm = [
      "ALT, mouse:272, movewindow"
    ];

    monitor = [
      "HDMI-A-1, 2560x1440@144, 2560x-820, 1, transform, 1"
      "DP-2, 2560x1440@165, 0x0, 1"
    ];

    exec-once = [
      # Start dank material shell
      "bash -c \"wl-paste --watch cliphist store &\""

      # Default open applications
      "[workspace 2 silent] zen-beta"
      "[workspace 6 silent] slack"
    ];
  };

  # XDG
  xdg.userDirs.enable = true;

  # GTK
  gtk.enable = true;
  gtk.colorScheme = "dark";

  gtk.theme.package = pkgs.adw-gtk3;
  gtk.theme.name = "adw-gtk3";

  gtk.font.name = default.fonts.sans.name;
  gtk.font.size = default.fonts.size;

  # Link dank shell to GTK
  xdg.configFile."gtk-4.0/gtk.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/gtk-4.0/dank-colors.css";
  xdg.configFile."gtk-3.0/gtk.css".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/gtk-3.0/dank-colors.css";

  gtk.iconTheme.package = pkgs.tela-circle-icon-theme.override { colorVariants = [ "purple" ]; };
  gtk.iconTheme.name = "Tela-circle-purple-dark";

  # Cursor
  home.pointerCursor.enable = true;
  home.pointerCursor.gtk.enable = true;
  home.pointerCursor.hyprcursor.enable = true;

  home.pointerCursor.name = "Bibata-Modern-Classic";
  home.pointerCursor.package = pkgs.bibata-cursors;
  home.pointerCursor.size = 24;

  # Dconf settings
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":";

  # QT
  qt.enable = true;
  qt.platformTheme.name = "gtk3";
}
