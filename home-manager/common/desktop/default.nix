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
    ./niriswitcher.nix
    ./swayosd.nix
    ./wallpaper.nix
  ];

  # screen-record
  home.packages =
    with pkgs;
    [
      wf-recorder
      slurp
      gifsicle
      zenity
    ]
    ++ (lib.optional (
      config.lib.monitors.otherMonitorsNames == [ ]
    ) self.packages.${pkgs.system}.record-screen);
}
