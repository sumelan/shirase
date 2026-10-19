{config, ...}: {
  flake.modules.nixos."hosts/minibookx" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        kdeconnect
        nix-secrets
        ;
    };

    networking.hostId = "8425e349";

    # Rotate limine interface
    boot.loader.limine.extraConfig = ''
      interface_rotation: 90
    '';
  };
}
