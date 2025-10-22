{ config, lib, ... }:
let
  capitalize =
    s: lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (builtins.stringLength s) s;

  theme.base = "https://raw.githubusercontent.com/catppuccin/zen-browser/refs/heads/main/themes/${capitalize config.catppuccin.flavor}/${capitalize config.catppuccin.accent}";

  theme.userChrome = builtins.fetchurl {
    url = "${theme.base}/userChrome.css";
    sha256 = "0vbcaydy5hchv56y1c17zylwv021dwbx92c7azpvbyf6djzlba22";
  };

  theme.userContent = builtins.fetchurl {
    url = "${theme.base}/userContent.css";
    sha256 = "0jnlgkmk2mswzrwfhis9skk6a9svc995bd1a9292hy94wr2kqyi9";
  };
in
{
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
  # programs.zen-browser.profiles.default.userChrome = builtins.readFile theme.userChrome;
  # programs.zen-browser.profiles.default.userContent = builtins.readFile theme.userContent;

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
  programs.zen-browser.policies =
    let
      mkExtensionSettings = builtins.mapAttrs (
        _: pluginId: {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
          installation_mode = "force_installed";
        }
      );
    in
    {
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

  # Set zen browser profile name to Stylix
  stylix.targets.zen-browser.profileNames = [ "default" ];

  # TODO Check why Zen Browser is not creating spaces and installing extensions in macOS
}
