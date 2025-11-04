{ osConfig, ... }:
{
  xdg.configFile."quickshell/Singletons/Theme.qml".source =
    "${osConfig.programs.matugen.theme.files}/.config/quickshell/theme.qml";
}
