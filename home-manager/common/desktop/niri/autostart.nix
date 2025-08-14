{
  lib,
  config,
  pkgs,
  ...
}: {
  programs.niri.settings.spawn-at-startup = let
    fish = cmd: [
      "fish"
      "-c"
      cmd
    ];
  in [
    # network
    {command = ["nm-applet"];}
    # bluetooth
    {command = ["blueman-applet"];}
    # clipboard manager
    {
      command = fish "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store";
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
