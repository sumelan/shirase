{config, ...}: {
  flake.modules.nixos."hosts/sakura" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        gui
        hdds
        audiobookshelf
        nix-secrets
        syncoid
        borgmatic
        sshConfig
        ;
    };

    networking.hostId = "8425e349";

    custom = {
      hardware = {
        hdds = {
          westernDigital = true;
          ironWolf = true;
        };
      };

      programs.btop.rocmSupport = true;
    };
  };
}
