{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.laptop = _: {
    imports = builtins.attrValues {
      inherit (flake.modules.nixos) wifi keyd;
    };

    # disbale USB after sometime of inactivity
    powerManagement.powertop.enable = true;

    services.libinput.enable = true;
  };
}
