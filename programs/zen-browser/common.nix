{ config, inputs, ... }:
let
  mkExtensionSettings = builtins.mapAttrs (
    _: pluginId: {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
      installation_mode = "force_installed";
    }
  );

  mkLockedAttrs = builtins.mapAttrs (
    _: value: {
      Value = value;
      Status = "locked";
    }
  );
in
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  # Zen browser configuration (stylix supported)
  programs.zen-browser.enable = true;

  # Languages
  programs.zen-browser.languagePacks = [
    "en-US"
    "pt-BR"
  ];

  # Profile
  programs.zen-browser.profiles.default.name = "Default";
  programs.zen-browser.profiles.default.isDefault = true;

  # Theme
  programs.zen-browser.profiles.default.userChrome = ''
    @import url("${config.home.homeDirectory}/.config/zen-browser/themes/user-chrome.css");
  '';
  programs.zen-browser.profiles.default.userContent = ''
    @import url("${config.home.homeDirectory}/.config/zen-browser/themes/user-content.css");
  '';

  # Search
  programs.zen-browser.profiles.default.search.default = "google";
  programs.zen-browser.profiles.default.search.force = true;

  # Containers
  programs.zen-browser.profiles.default.containers.personal.id = 0;
  programs.zen-browser.profiles.default.containers.personal.name = "Personal";
  programs.zen-browser.profiles.default.containers.personal.color = "blue";
  programs.zen-browser.profiles.default.containers.personal.icon = "fingerprint";

  programs.zen-browser.profiles.default.containers.college.id = 1;
  programs.zen-browser.profiles.default.containers.college.name = "College";
  programs.zen-browser.profiles.default.containers.college.color = "green";
  programs.zen-browser.profiles.default.containers.college.icon = "chill";

  programs.zen-browser.profiles.default.containers.work.id = 2;
  programs.zen-browser.profiles.default.containers.work.name = "Work";
  programs.zen-browser.profiles.default.containers.work.color = "yellow";
  programs.zen-browser.profiles.default.containers.work.icon = "briefcase";

  programs.zen-browser.profiles.default.containersForce = true;

  # Spaces
  programs.zen-browser.profiles.default.spaces.personal.id = "47e66c69-815b-40cb-8b41-be4fcf7a2c59";
  programs.zen-browser.profiles.default.spaces.personal.container = 0;
  programs.zen-browser.profiles.default.spaces.personal.name = "Personal";
  programs.zen-browser.profiles.default.spaces.personal.position = 0;

  programs.zen-browser.profiles.default.spaces.college.id = "26214a33-e220-4695-8730-e28722d0a60a";
  programs.zen-browser.profiles.default.spaces.college.container = 1;
  programs.zen-browser.profiles.default.spaces.college.name = "UFABC";
  programs.zen-browser.profiles.default.spaces.college.position = 1;

  programs.zen-browser.profiles.default.spaces.work.id = "f700d4a8-e760-4aa5-9ada-ddc57a73454b";
  programs.zen-browser.profiles.default.spaces.work.container = 2;
  programs.zen-browser.profiles.default.spaces.work.name = "Intelipost";
  programs.zen-browser.profiles.default.spaces.work.position = 2;

  programs.zen-browser.profiles.default.spacesForce = true;

  # Policies
  programs.zen-browser.policies = {
    AutofillAddressEnabled = false;
    AutofillCreditCardEnabled = false;
    DisableAppUpdate = true;
    DisableFeedbackCommands = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    TranslateEnabled = false;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
    ExtensionSettings = mkExtensionSettings {
      "uBlock0@raymondhill.net" = "ublock-origin"; # uBlock
      "sponsorBlocker@ajay.app" = "sponsorblock"; # Sponsor block
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager"; # Bitwarden

      "control-panel-for-youtube@jbscript.dev" = "control-panel-for-youtube"; # Control panel for YT
      "{5cce4ab5-3d47-41b9-af5e-8203eea05245}" = "control-panel-for-twitter"; # Control panel for Twitter
      "twitch5@coolcmd" = "twitch_5"; # Twitch custom player

      "{6def1df3-6313-4648-a6ca-945b92aba510}" = "no-google-search-translation"; # Disable google search translation

      "foxyproxy@eric.h.jung" = "foxyproxy-standard"; # Proxy
    };
    Preferences = mkLockedAttrs {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    };
  };

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
