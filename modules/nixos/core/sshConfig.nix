{
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkOption;
  inherit (pkgs.lib.types) str;
  cfg = config.custom.programs.ssh;
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
        ''
          Host sakura
            HostName 192.168.68.62
            Port 22
            User sumelan

            # Prevent using ssh-agent or another keyfile,
            # useful for testing
            IdentitiesOnly yes
            IdentityFile ~/.ssh/id_ed25519

          Host minibookx
            HostName 192.168.68.56
            Port 22
            User sumelan

            # Prevent using ssh-agent or another keyfile,
            # useful for testing
            IdentitiesOnly yes
            IdentityFile ~/.ssh/id_ed25519

          Host acer
            HostName 192.168.68.55
            Port 22
            User sumelan

            # Prevent using ssh-agent or another keyfile,
            # useful for testing
            IdentitiesOnly yes
            IdentityFile ~/.ssh/id_ed25519

          Host omen
            HostName 192.168.68.53
            Port 22
            User sumelan

            # Prevent using ssh-agent or another keyfile,
            # useful for testing
            IdentitiesOnly yes
            IdentityFile ~/.ssh/id_ed25519
        ''
        + cfg.extraConfig;
    };
  };
}
