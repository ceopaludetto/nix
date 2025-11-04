{ default, inputs, ... }:
let
  templates = ../../assets/templates;
in
{
  imports = [
    inputs.matugen.nixosModules.default
  ];

  programs.matugen.enable = true;
  programs.matugen.variant = "dark";
  programs.matugen.jsonFormat = "hex";
  programs.matugen.type = "scheme-content";
  programs.matugen.wallpaper = default.wallpaper.inPNG;

  # Templates
  programs.matugen.templates = {
    # Discord
    discord.input_path = "${templates}/discord.css";
    discord.output_path = "~/.config/vesktop/themes/discord.css";

    # Ghostty
    ghostty.input_path = "${templates}/ghostty";
    ghostty.output_path = "~/.config/ghostty/themes/Matugen";

    # GTK 4
    gtk4.input_path = "${templates}/gtk.css";
    gtk4.output_path = "~/.config/gtk-4.0/gtk.css";

    # GTK 3
    gtk3.input_path = "${templates}/gtk.css";
    gtk3.output_path = "~/.config/gtk-3.0/gtk.css";

    # Quickshell
    quickshell.input_path = "${templates}/quickshell.qml";
    quickshell.output_path = "~/.config/quickshell/theme.qml";

    # Zed
    zed.input_path = "${templates}/zed.json";
    zed.output_path = "~/.config/zed/themes/matugen.json";
  };

  programs.matugen.config = {
    custom_keywords.fontSans = default.fonts.sans.name;
    custom_keywords.fontMono = default.fonts.mono.name;

    custom_keywords.gap = builtins.toString default.window.gap;
    custom_keywords.margin = builtins.toString default.window.margin;
    custom_keywords.radius = builtins.toString default.window.radius;
  };
}
