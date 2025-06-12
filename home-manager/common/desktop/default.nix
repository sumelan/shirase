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
    ./dunst.nix
    ./fuzzel.nix
    ./image.nix
    ./nautilus.nix
    ./swayosd.nix
    ./wallpaper.nix
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
