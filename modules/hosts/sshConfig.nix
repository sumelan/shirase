{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
  inherit (lib) mkOption;
  inherit (lib.types) str;
in {
  flake.modules.nixos.default = {config, ...}: let
    cfg = config.custom.programs.ssh;
    inherit (flake.custom.userModules) sshConfig;
  in {
    options.custom = {
      programs.ssh = {
        extraConfig = mkOption {
          type = str;
          default = "";
          description = ''
            Additional configuration text prepended to `ssh_config`.
          '';
        };
      };
    };

    config = {
      programs.ssh = {
        extraConfig =
          sshConfig.sakura
          + sshConfig.minibookx
          + sshConfig.acer
          + sshConfig.omen
          + cfg.extraConfig;
      };
    };
  };
}
