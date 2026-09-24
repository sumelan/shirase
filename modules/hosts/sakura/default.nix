{config, ...}: {
  flake.modules.nixos."hosts/sakura" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        gui
        kdeconnect
        #  hdds
        qmk
        trackpad
        #  audiobookshelf
        nix-secrets
        #  syncoid
        #  syncthing
        sshConfig
        hjem-extended
        ;
    };

    networking.hostId = "8425e349";

    custom = {
      #   hardware = {
      #     hdds = {
      #       westernDigital = true;
      #       ironWolf = true;
      #     };
      #   };

      programs.btop.rocmSupport = true;
    };
  };
}
