{ ... }:
{
  imports = [
    ./common.nix
  ];

  # Use Vesktop instead of Discord
  programs.nixcord.discord.enable = false;
  programs.nixcord.vesktop.enable = true;
}
