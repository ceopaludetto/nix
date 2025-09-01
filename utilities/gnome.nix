{ lib, ... }:
with lib.hm.gvariant;
{
  dconf.enable = true;

  # Wallpaper
  dconf.settings."org/gnome/desktop/background".picture-uri = ../assets/wallpaper.heic;

  # Desktop configuration
  dconf.settings."org/gnome/desktop/interface".accent-color = "yellow";
  dconf.settings."org/gnome/desktop/interface".clock-show-weekday = true;
  dconf.settings."org/gnome/desktop/interface".text-scaling-factor = 1.01;
  dconf.settings."org/gnome/desktop/interface".font-hinting = "full";
  dconf.settings."org/gnome/desktop/interface".font-antialiasing = "rgba";
  dconf.settings."org/gnome/desktop/wm/preferences".button-layout = ":minimize,maximize,close";

  # Shell configuration
  dconf.settings."org/gnome/shell".disable-user-extensions = false;

  # Mutter configuration
  dconf.settings."org/gnome/mutter".experimental-features = [
    "scale-monitor-framebuffer"
    "variable-refresh-rate"
    "xwayland-native-scaling"
  ];

  # Rounded window corners configuration
  dconf.settings."org/gnome/shell/extensions/rounded-window-corners-reborn".blacklist = [
    "dev.zed.Zed"
  ];

  # Blur my shell configuration
  dconf.settings."org/gnome/shell/extensions/blur-my-shell".pipelines = mkVariant [
    (mkDictionaryEntry [
      "pipeline_default"
      (mkVariant [
        (mkDictionaryEntry [
          "name"
          (mkVariant "Default")
        ])
        (mkDictionaryEntry [
          "effects"
          (mkVariant [
            (mkVariant [
              (mkDictionaryEntry [
                "type"
                (mkVariant "native_static_gaussian_blur")
              ])
              (mkDictionaryEntry [
                "id"
                (mkVariant "effect_000000000000")
              ])
              (mkDictionaryEntry [
                "params"
                (mkVariant [
                  (mkDictionaryEntry [
                    "radius"
                    (mkVariant 30)
                  ])
                  (mkDictionaryEntry [
                    "brightness"
                    (mkVariant 0.6)
                  ])
                ])
              ])
            ])
          ])
        ])
      ])
    ])
  ];

  dconf.settings."org/gnome/shell/extensions/blur-my-shell/lockscreen".blur = true;
  dconf.settings."org/gnome/shell/extensions/blur-my-shell/lockscreen".pipeline = "pipeline_default";

  dconf.settings."org/gnome/shell/extensions/blur-my-shell/overview".blur = true;
  dconf.settings."org/gnome/shell/extensions/blur-my-shell/overview".pipeline = "pipeline_default";

  dconf.settings."org/gnome/shell/extensions/blur-my-shell/screenshot".blur = true;
  dconf.settings."org/gnome/shell/extensions/blur-my-shell/screenshot".pipeline = "pipeline_default";

  dconf.settings."org/gnome/shell/extensions/blur-my-shell/panel".applications = false;
  dconf.settings."org/gnome/shell/extensions/blur-my-shell/panel".blur = false;
  dconf.settings."org/gnome/shell/extensions/blur-my-shell/panel".coverflow-alt-tab = false;
  dconf.settings."org/gnome/shell/extensions/blur-my-shell/panel".dash-to-dock = false;
}
