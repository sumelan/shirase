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
in {
  services = mkMerge [
    # power management
    {
      upower.enable = true;
      power-profiles-daemon.enable = true; # conflict with TLP
    }
    (mkIf isLaptop {
      libinput.enable = true;
    })
  ];
}
