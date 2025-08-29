{...}: {
  programs.zen-browser.enable = true;

  # Languages
  programs.zen-browser.languagePacks = [
    "en-US"
    "pt-BR"
  ];

  # Profile
  programs.zen-browser.profiles.default.name = "Default";
  programs.zen-browser.profiles.default.isDefault = true;

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

  programs.zen-browser.profiles.default.containersForce = true;

  # Spaces
  programs.zen-browser.profiles.default.spaces.personal.id = "4d326c08-aeec-44ca-9077-26e5ba683f20";
  programs.zen-browser.profiles.default.spaces.personal.container = 0;
  programs.zen-browser.profiles.default.spaces.personal.name = "Personal";
  programs.zen-browser.profiles.default.spaces.personal.position = 0;

  programs.zen-browser.profiles.default.spaces.college.id = "b7278d4e-151d-4ff6-a76f-b0d8ab08dc17";
  programs.zen-browser.profiles.default.spaces.college.container = 1;
  programs.zen-browser.profiles.default.spaces.college.name = "UFABC";
  programs.zen-browser.profiles.default.spaces.college.position = 1;

  programs.zen-browser.profiles.default.spacesForce = true;

  # Policies
  programs.zen-browser.policies = let
    mkExtensionSettings = builtins.mapAttrs (
      _: pluginId: {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
        installation_mode = "force_installed";
      }
    );
  in {
    AutofillAddressEnabled = true;
    AutofillCreditCardEnabled = false;
    DisableAppUpdate = true;
    DisableFeedbackCommands = true;
    DisableFirefoxStudies = true;
    DisablePocket = true;
    DisableTelemetry = true;
    DontCheckDefaultBrowser = true;
    NoDefaultBookmarks = true;
    OfferToSaveLogins = false;
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };
    ExtensionSettings = mkExtensionSettings {
      # AdBlocker
      "uBlock0@raymondhill.net" = "ublock-origin";
      # YouTube
      "sponsorBlocker@ajay.app" = "sponsorblock";
      "control-panel-for-youtube@jbscript.dev" = "control-panel-for-youtube";
      # Twitter
      "{5cce4ab5-3d47-41b9-af5e-8203eea05245}" = "control-panel-for-twitter";
      # Bitwarden
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
      # Twitch
      "twitch5@coolcmd" = "twitch_5";
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

  stylix.targets.zen-browser.profileNames = ["default"];
}
