{config, ...}: {
  flake.modules.nixos."hosts/omen" = _: let
    inherit (config.flake.custom.userModules) sshConfig;
  in {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nixos)
        kdeconnect
        qmk
        trackpad
        nix-secrets
        steam
        syncoid
        ;
    };

    networking.hostId = "8425e349";

    custom = {
      programs = {
        ssh.extraConfig = sshConfig.sakura-syncoid + sshConfig.sakura-initrd;
        btop.cudaSupport = true;
      };
    };
  };
}
