{
  lib,
  isLaptop,
  ...
}: let
  inherit (lib) optionalString;
  laptopBrightness = optionalString isLaptop ''
    spawn-at-startup "brightnessctl" "set" "5%"
  '';
in {
  xdg.configFile."niri/spawn.kdl".text =
    # kdl
    ''
      spawn-at-startup "easyeffects" "--hide-window"
      spawn-at-startup "nm-applet"
      spawn-at-startup "blueman-applet"
      ${laptopBrightness}
    '';
}
