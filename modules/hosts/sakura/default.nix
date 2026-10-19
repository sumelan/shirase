{config, ...}: {
  flake.modules.nixos."hosts/sakura" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        hdds
        audiobookshelf
        nix-secrets
        syncoid
        borgmatic
        ;
    };

    networking.hostId = "8425e349";

    custom = {
      programs = {
        btop.rocmSupport = true;
      };

      hardware.hdds = {
        westernDigital = true;
        ironWolf = true;
      };
    };
  };
}
