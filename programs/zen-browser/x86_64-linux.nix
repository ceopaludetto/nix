{ ... }:
{
  imports = [
    ./common.nix
  ];

  # XDG Desktop entry with fixed icon
  xdg.desktopEntries.zen-beta.name = "Zen Browser";
  xdg.desktopEntries.zen-beta.genericName = "Web Browser";

  xdg.desktopEntries.zen-beta.exec = "zen-beta --name zen-beta %U";
  xdg.desktopEntries.zen-beta.icon = "io.github.zen_browser.zen";

  xdg.desktopEntries.zen-beta.startupNotify = true;
  xdg.desktopEntries.zen-beta.terminal = false;
  xdg.desktopEntries.zen-beta.type = "Application";

  xdg.desktopEntries.zen-beta.categories = [
    "Network"
    "WebBrowser"
  ];

  xdg.desktopEntries.zen-beta.mimeType = [
    "text/html"
    "text/xml"
    "application/xhtml+xml"
    "application/vnd.mozilla.xul+xml"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
  ];

  xdg.desktopEntries.zen-beta.actions."new-private-window".name = "New Private Window";
  xdg.desktopEntries.zen-beta.actions."new-private-window".exec = "zen-beta --private-window %U";

  xdg.desktopEntries.zen-beta.actions."new-window".name = "New Window";
  xdg.desktopEntries.zen-beta.actions."new-window".exec = "zen-beta --new-window %U";

  xdg.desktopEntries.zen-beta.actions."profile-manager-window".name = "Profile Manager";
  xdg.desktopEntries.zen-beta.actions."profile-manager-window".exec = "zen-beta --ProfileManager";
}
