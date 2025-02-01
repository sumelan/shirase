{ isLaptop, lib, ... }:
{
  specialisation =
    {
      # boot into a tty without a DE / WM
      tty.configuration = {
        hm.custom.hyprland.enable = lib.mkForce false;

        services = {
          xserver = {
            enable = lib.mkForce false;
          };
        };
      };
    }
    # create an otg specialisation for laptops
    // lib.optionalAttrs isLaptop {
      otg.configuration = { };
    };
}
