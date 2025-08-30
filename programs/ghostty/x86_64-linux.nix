{...}: {
  imports = [
    ./common.nix
  ];

  programs.ghostty.settings.window-theme = "ghostty";
  programs.ghostty.settings.gtk-tabs-location = "hidden";
  programs.ghostty.settings.adw-toolbar-style = "flat";

  # XDG Desktop entry with fixed icon
  xdg.desktopEntries."com.mitchellh.ghostty".name = "Ghostty";
  xdg.desktopEntries."com.mitchellh.ghostty".genericName = "A terminal emulator";

  xdg.desktopEntries."com.mitchellh.ghostty".exec = "ghostty";
  xdg.desktopEntries."com.mitchellh.ghostty".icon = ../assets/icons/ghostty.svg;

  xdg.desktopEntries."com.mitchellh.ghostty".startupNotify = true;
  xdg.desktopEntries."com.mitchellh.ghostty".terminal = false;
  xdg.desktopEntries."com.mitchellh.ghostty".type = "Application";

  xdg.desktopEntries."com.mitchellh.ghostty".categories = [
    "System"
    "TerminalEmulator"
  ];

  xdg.desktopEntries."com.mitchellh.ghostty".actions."new-window".name = "New Window";
  xdg.desktopEntries."com.mitchellh.ghostty".actions."new-window".exec = "ghostty";

  xdg.desktopEntries."com.mitchellh.ghostty".settings = {
    Keywords = "terminal;tty;pty;";
    StartupWMClass = "com.mitchellh.ghostty";

    X-GNOME-UsesNotifications = "true";
    X-TerminalArgExec = "-e";
    X-TerminalArgTitle = "--title=";
    X-TerminalArgAppId = "--class=";
    X-TerminalArgDir = "--working-directory=";
    X-TerminalArgHold = "--wait-after-command";
  };
}
