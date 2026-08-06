{config, ...}: {
  flake.modules.nixos.laptop = _: {
    imports = builtins.attrValues {
      inherit (config.flake.modules.nixos) wifi keyd;
    };

    # disbale USB after sometime of inactivity
    powerManagement.powertop.enable = true;

    services.libinput.enable = true;
  };
}
