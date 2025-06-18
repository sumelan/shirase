{
  lib,
  config,
  pkgs,
  self,
  ...
}:
{
  imports = [
    ./niri
    ./way-edges
    ./waybar
    ./discord.nix
    ./dunst.nix
    ./easyeffects.nix
    ./fuzzel.nix
    ./kitty.nix
    ./librewolf.nix
    ./mpv.nix
    ./nautilus.nix
    ./nixlogo.nix
    ./swayimg.nix
    ./swayosd.nix
    ./wallpaper.nix
    ./yazi.nix
    ./youtube-music.nix
  ];

  # screen-record
  home.packages = lib.mkIf (config.lib.monitors.otherMonitorsNames == [ ]) [
    pkgs.wf-recorder
    pkgs.slurp
    pkgs.gifsicle
    pkgs.zenity
    self.packages.${pkgs.system}.record-screen
  ];
}
