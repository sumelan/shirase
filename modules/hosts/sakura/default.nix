{config, ...}: {
  flake.modules.nixos."hosts/sakura" = _: {
    imports = builtins.attrValues {
      inherit (config.flake.modules.nixos) minisforum-um773se;
      inherit
        (config.flake.modules.nixos)
        gui
        kdeconnect
        hdds
        qmk
        trackpad
        audiobookshelf
        nix-secrets
        syncoid
        syncthing
        sshConfig
        hjem-extended
        ;
    };

    networking.hostId = "b5e8f0be";

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
