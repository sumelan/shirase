{
  lib,
  isLaptop,
  ...
}: let
  inherit (lib) mkMerge mkIf;
in
  mkMerge [
    {
      powerManagement.enable = true;
      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true; # conflict with TLP
        tlp.enable = false;
      };
    }
    (mkIf isLaptop {
      services.libinput.enable = true;
      # It disabled usb after some time of inativity, so not usable on desktop
      powerManagement.powertop.enable = true;
    })
  ]
