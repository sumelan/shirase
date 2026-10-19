{config, ...}: {
  flake.modules.nixos."hosts/minibookx" = _: let
    inherit (config.flake.custom.userModules) sshConfig;
  in {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        kdeconnect
        nix-secrets
        ;
    };

    # Rotate limine interface
    boot.loader.limine.extraConfig = ''
      interface_rotation: 90
    '';

    networking.hostId = "8425e349";

    custom = {
      programs = {
        ssh.extraConfig = sshConfig.sakura-initrd;
      };
    };
  };
}
