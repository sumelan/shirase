{config, ...}: {
  flake.modules.nixos."hosts/omen" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        gui
        kdeconnect
        nix-secrets
        sshConfig
        ;
    };

    networking.hostId = "8425e349";
  };
}
