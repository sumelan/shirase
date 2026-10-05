{config, ...}: {
  flake.modules.nixos."hosts/omen" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        gui
        kdeconnect
        qmk
        trackpad
        nix-secrets
        steam
        sshConfig
        syncoid
        ;
    };

    networking.hostId = "8425e349";

    custom = {
      programs.btop = {
        cudaSupport = true;
      };
    };
  };
}
