{config, ...}: {
  flake.modules.nixos."hosts/acer" = _: {
    imports = builtins.attrValues {
      inherit (config.flake.modules.nixos) acer-al14;
      inherit
        (config.flake.modules.nixos)
        gui
        kdeconnect
        nix-secrets
        sshConfig
        ;
    };

    networking.hostId = "22fe2870";
  };
}
