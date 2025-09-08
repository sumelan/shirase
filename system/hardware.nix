{
  lib,
  isLaptop,
  ...
}: let
  inherit
    (lib)
    mkMerge
    mkIf
    ;
in
  mkMerge [
    {
      powerManagement = {
        enable = true;
        # It disabled usb after some time of inativity, so not usable on desktop
        powertop.enable = mkIf isLaptop true;
      };
      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true; # conflict with TLP
        tlp.enable = false;
      };
    }
    {
      services.libinput.enable = mkIf isLaptop true;
    }
  ]
