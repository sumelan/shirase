{config, ...}: {
  flake.modules.nixos.sshConfig = _: let
    inherit (config.flake.custom.userModules.sshConfig) sakura;
  in {
    programs.ssh = {
      extraConfig = sakura;
    };
  };
}
