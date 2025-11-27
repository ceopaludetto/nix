{ config, ... }:
{
  sops.defaultSopsFile = ../assets/secrets.yaml;
  sops.age.keyFile =
    with config.home-manager.users.carlos;
    builtins.toString home.homeDirectory + "/.config/sops/age/keys.txt";

  sops.secrets = {
    "carlos.paludetto@intelipost.com.br/password" = { };
    "carlos.paludetto@outlook.com/password" = { };
    "ceo.paludetto@gmail.com/password" = { };
    "wifi/password" = { };
  };
}
