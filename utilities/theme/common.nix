{
  config,
  inputs,
  osConfig,
  system,
  ...
}:
let
  templates = ../../assets/templates;
  homeDirectory =
    if system.isDarwin then osConfig.user.users.carlos.home else config.home.homeDirectory;
in
{
  imports = [
    inputs.matugen.nixosModules.default
  ];

  xdg.configFile."matugen/config.toml".text = ''
    [config]

    [templates.vscode]
    input_path = "${templates}/vscode/theme.json"
    output_path = "${homeDirectory}/.config/vscode-oss/themes/matugen.json"

    [templates.zen-browser-user-chrome]
    input_path = "${templates}/zen-browser/user-chrome.css"
    output_path = "${homeDirectory}/.config/zen-browser/themes/user-chrome.css"

    [templates.zen-browser-user-content]
    input_path = "${templates}/zen-browser/user-content.css"
    output_path = "${homeDirectory}/.config/zen-browser/themes/user-content.css"
  '';
}
