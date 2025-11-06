{ config, inputs, ... }:
let
  templates = ../../assets/templates;
in
{
  imports = [
    inputs.matugen.nixosModules.default
  ];

  xdg.configFile."matugen/config.toml".text = ''
    [config]

    [templates.discord]
    input_path = "${templates}/discord.css"
    output_path = "${config.home.homeDirectory}/.config/vesktop/themes/discord.css"

    [templates.zed]
    input_path = "${templates}/zed.json"
    output_path = "${config.home.homeDirectory}/.config/zed/themes/matugen.json"

    [templates.zen-browser-user-chrome]
    input_path = "${templates}/zen-user-chrome.css"
    output_path = "${config.home.homeDirectory}/.config/zen-browser/themes/user-chrome.css"

    [templates.zen-browser-user-content]
    input_path = "${templates}/zen-user-content.css"
    output_path = "${config.home.homeDirectory}/.config/zen-browser/themes/user-content.css"
  '';
}
