{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}:
let
  android.path = "Android/Sdk";
  android.sdk = inputs.android.sdk.${system.triple} (
    sdk:
    with sdk;
    [
      cmdline-tools-latest
      emulator
      platform-tools
      tools

      # Android 36
      build-tools-36-0-0
      platforms-android-36

      # Android 35
      build-tools-35-0-0
      platforms-android-35

      # Android 34
      build-tools-34-0-0
      platforms-android-34

      # Emulator
      sources-android-36

      # Flutter
      cmake-3-22-1
      ndk-28-2-13676358
      ndk-27-0-12077973
      ndk-25-2-9519653
    ]
    ++ lib.optionals (system.triple == "x86_64-linux") [
      system-images-android-36-google-apis-playstore-x86-64
    ]
    ++ lib.optionals (system.triple == "aarch64-darwin") [
      system-images-android-36-google-apis-playstore-arm64-v8a
    ]
  );
in
{
  home.packages = [
    android.sdk
  ]
  ++ lib.optionals (system.triple == "x86_64-linux") [
    pkgs.android-studio
  ];

  home.file.${android.path}.source = "${android.sdk}/share/android-sdk";

  home.sessionVariables = {
    ANDROID_HOME = "${config.home.homeDirectory}/${android.path}";
    ANDROID_SDK_ROOT = "${config.home.homeDirectory}/${android.path}";
  };
}
