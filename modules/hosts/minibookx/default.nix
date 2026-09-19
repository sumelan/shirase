{config, ...}: {
  flake.modules.nixos."hosts/minibookx" = _: {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        gui
        kdeconnect
        nix-secrets
        syncthing
        sshConfig
        ;
    };

    networking.hostId = "56895d2b";

    # Rotate limine interface
    boot.loader.limine.extraConfig = ''
      interface_rotation: 90
    '';
  };
}
