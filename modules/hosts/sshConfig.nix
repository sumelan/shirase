{config, ...}: {
  flake.modules.nixos.sshConfig = _: let
    ssh = config.flake.custom.userModules.sshConfig;
  in {
    programs.ssh = {
      extraConfig =
        ssh.sakura
        + ssh.sakura-remote
        + ssh.minibookx
        + ssh.acer
        + ssh.omen;
    };
  };
}
