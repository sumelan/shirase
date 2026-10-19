{config, ...}: {
  flake.modules.nixos."hosts/acer" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        kdeconnect
        nix-secrets
        ;
    };

    networking.hostId = "22fe2870";
  };
}
