{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf config.custom.niri.enable {
  programs.niri.settings.spawn-at-startup =
    let
      fish = cmd: [
        "fish"
        "-c"
        cmd
      ];
    in
    [
      {
        command = fish "nm-applet";
      }
      # clipboard manager
      {
        command = fish "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store";
      }
      (lib.optionalAttrs config.custom.backlight.enable {
        command = fish "${lib.getExe pkgs.brightnessctl} set 5%";
      })
    ];
}
