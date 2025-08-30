{...}: {
  imports = [
    ./common.nix
  ];

  # Use Discord instead of Vesktop
  programs.nixcord.discord.enable = true;
  programs.nixcord.vesktop.enable = false;
}
