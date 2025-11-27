{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cat = path: "${lib.getExe' pkgs.coreutils "cat"} ${path}";
in
{
  accounts.calendar.basePath = ".calendar";
  accounts.calendar.accounts = with osConfig.sops; {
    "Personal".primary = true;
    "Personal".khal.enable = true;
    "Personal".thunderbird.enable = true;
    "Personal".remote.type = "caldav";
    "Personal".remote.url =
      "https://apidata.googleusercontent.com/caldav/v2/ceo.paludetto@gmail.com/events/";
    "Personal".remote.userName = "ceo.paludetto@gmail.com";
    "Personal".remote.passwordCommand = cat secrets."ceo.paludetto@gmail.com/password".path;

    "Work".khal.enable = true;
    "Work".thunderbird.enable = true;
    "Work".remote.type = "caldav";
    "Work".remote.url =
      "https://apidata.googleusercontent.com/caldav/v2/carlos.paludetto@intelipost.com.br/events/";
    "Work".remote.userName = "carlos.paludetto@intelipost.com.br";
    "Work".remote.passwordCommand = cat secrets."carlos.paludetto@intelipost.com.br/password".path;
  };

  accounts.email.maildirBasePath = ".mail";
  accounts.email.accounts = with osConfig.sops; {
    "Personal".primary = true;
    "Personal".flavor = "gmail.com";
    "Personal".realName = "Carlos Eduardo de Oliveira Paludetto";
    "Personal".address = "ceo.paludetto@gmail.com";
    "Personal".passwordCommand = cat secrets."ceo.paludetto@gmail.com/password".path;
    "Personal".mbsync.enable = true;
    "Personal".mbsync.create = "maildir";
    "Personal".thunderbird.enable = true;

    "Outlook".flavor = "outlook.office365.com";
    "Outlook".realName = "Carlos Eduardo de Oliveira Paludetto";
    "Outlook".address = "carlos.paludetto@outlook.com";
    "Outlook".passwordCommand = cat secrets."carlos.paludetto@outlook.com/password".path;
    "Outlook".mbsync.enable = true;
    "Outlook".mbsync.create = "maildir";
    "Outlook".thunderbird.enable = true;

    "Work".flavor = "gmail.com";
    "Work".realName = "Carlos Eduardo de Oliveira Paludetto";
    "Work".address = "carlos.paludetto@intelipost.com.br";
    "Work".passwordCommand = cat secrets."carlos.paludetto@intelipost.com.br/password".path;
    "Work".mbsync.enable = true;
    "Work".mbsync.create = "maildir";
    "Work".thunderbird.enable = true;
  };

  programs.mbsync.enable = true;
  services.mbsync.enable = true;

  programs.khal.enable = true;

  programs.thunderbird.enable = true;
  programs.thunderbird.settings = {
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "svg.context-properties.content.enabled" = true;
  };
  programs.thunderbird.profiles."default" = {
    isDefault = true;

    userChrome = ''
      @import "thunderbird-gnome-theme/userChrome.css";
    '';
    userContent = ''
      @import "thunderbird-gnome-theme/userContent.css";
    '';
  };

  home.file."thunderbird-gnome-theme" = {
    target = ".thunderbird/default/chrome/thunderbird-gnome-theme";
    source = pkgs.fetchFromGitHub {
      owner = "rafaelmardojai";
      repo = "thunderbird-gnome-theme";
      rev = "8b9a19eb188b3ede65e8f12a11637bbd56e4f4d7";
      hash = "sha256-aQAlgHsBAS+DdyYDlYhW/xT86xIu9FO8yJEzSCVaSBg=";
    };
  };
}
