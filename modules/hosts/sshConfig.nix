{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.sshConfig = _: let
    inherit (flake.custom.userModules.sshConfig) sakura;
  in {
    programs.ssh = {
      extraConfig = sakura;
    };
  };
}
