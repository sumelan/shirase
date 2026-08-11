{config, ...}: {
  flake.modules.nixos.sshConfig = _: let
    ssh = config.flake.custom.userModules.sshConfig;
  in {
    programs.ssh = {
      extraConfig = ssh.sakura + ssh.minibookx + ssh.acer;
    };
  };
}
