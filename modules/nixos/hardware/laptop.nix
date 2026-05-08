{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.laptop = _: {
    imports = with flake.modules.nixos; [keyd];

    # disbale USB after sometime of inactivity
    powerManagement.powertop.enable = true;

    services.libinput.enable = true;
  };
}
