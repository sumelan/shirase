{
  config,
  pkgs,
  ...
}: let
  inherit
    (pkgs.lib)
    mkIf
    getExe'
    getExe
    ;
in {
  security.nix-secrets.secrets = mkIf config.services.borgmatic.enable {
    "borgmatic/encryption" = {};
  };

  services.borgmatic = {
    configurations = let
      settings = {
        checks = [
          {
            name = "repository";
            frequency = "2 weeks";
          }
          {
            name = "archives";
            frequency = "4 weeks";
          }
          {
            name = "data";
            frequency = "6 weeks";
          }
          {
            name = "extract";
            frequency = "6 weeks";
          }
        ];

        keep_daily = 7;
        keep_weekly = 4;
        keep_monthly = 6;

        ssh_command = "ssh -i /root/.ssh/id_ed25519";

        encryption_passcommand =
          # sh
          ''${getExe' pkgs.uutils-coreutils-noprefix.out "cat"} ${config.security.nix-secrets.secrets."borgmatic/encryption".path}'';

        zfs = {
          zfs_command = getExe config.boot.zfs.package;
          mount_command = getExe' pkgs.unixtools.util-linux.out "mount";
          umount_command = getExe' pkgs.unixtools.util-linux.out "umount";
        };
      };
    in {
      backups =
        mkIf config.custom.hardware.hdds.ironWolf
        ({
            patterns = [
              "R /backups"
            ];
            repositories = [
              {
                label = "borgbase";
                path = "ssh://l78rf7w1@l78rf7w1.repo.borgbase.com/./repo";
              }
            ];
          }
          // settings);

      media =
        mkIf config.custom.hardware.hdds.westernDigital
        ({
            patterns = [
              "R /media"
            ];
            repositories = [
              {
                label = "borgbase";
                path = "ssh://huyey7vy@huyey7vy.repo.borgbase.com/./repo";
              }
            ];
          }
          // settings);
    };
  };
}
