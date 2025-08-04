{
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.niri.settings.spawn-at-startup =
    let
      fish = cmd: [
        "fish"
        "-c"
        cmd
      ];
    in
    [
      # network
      { command = [ "nm-applet" ]; }
      # bluetooth
      { command = [ "blueman-applet" ]; }
      # clipboard manager
      {
        command = fish "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store";
      }
      {
        command = lib.mkIf config.custom.niri.xwayland.enable [
          config.programs.niri.settings.xwayland-satellite.path
        ];
      }
      # initial backlight
      (lib.optionalAttrs config.custom.backlight.enable {
        command = [
          "${lib.getExe pkgs.brightnessctl}"
          "set"
          "5%"
        ];
      })
    ];
}
