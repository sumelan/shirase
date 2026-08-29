{lib, ...}: {
  flake.modules.nixos."hosts/sakura" = {
    config,
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user}.rum = {
      services.borgmatic = {
        enable = true;

        systemd = {
          enable = true;
          frequency = "daily";
        };

        configurations = {
          home = {
            source_directories = [
              "/persist/home/sumelan/Documents"
              "/persist/home/sumelan/Music"
              "/persist/home/sumelan/Pictures"
              "/persist/home/sumelan/Videos"
            ];
            repositories = [
              {
                label = "borgbase";
                path = "ssh://whcwf2xd@whcwf2xd.repo.borgbase.com/./repo";
              }
            ];

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

            ssh_command = "ssh -i /home/sumelan/.ssh/borgbase";
            encryption_passcommand =
              # sh
              ''${lib.getExe pkgs.bitwarden-cli} get password Borgmatic --session 2bQ7xQ4SpZ1e0084VdX/PCzwqiyZ0Ase6xmg8g/8kFlS6MU/En7qPwNP2DRDsx8m4HBsQ/RiFdy++i0fxmw30g=='';

            zfs = {
              zfs_command = lib.getExe config.boot.zfs.package;
            };
          };

          audiobookshelf = {
            source_directories = ["/persist/var/lib/audiobookshelf"];
            repositories = [
              {
                label = "borgbase";
                path = "ssh://ynlt03ko@ynlt03ko.repo.borgbase.com/./repo";
              }
            ];

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

            ssh_command = "ssh -i /home/sumelan/.ssh/borgbase";
            encryption_passcommand = "${lib.getExe pkgs.bitwarden-cli} get password Borgmatic --session cbv3d7IVNpJVZpQN5+VDIqVvNhpeDiUDBog2mGdtnMz2ZOJY5eg27UPCaUUuaQNenH/L0UudNVI8FM1/uBDodA=";

            zfs = {
              zfs_command = lib.getExe config.boot.zfs.package;
            };
          };
        };
      };
    };

    system = let
      cfg = config.hjem.users.${user}.rum.services.borgmatic;

      yamlFmt = pkgs.formats.yaml {};

      configFiles =
        lib.mapAttrs' (
          name: value:
            lib.nameValuePair "borgmatic.d/${name}.yaml" {
              source = yamlFmt.generate "${name}.yaml" value;
            }
        )
        cfg.configurations;

      borgmaticCheck = name: f:
        pkgs.runCommandCC "${name} validation" {} ''
          ${pkgs.borgmatic}/bin/borgmatic -c ${f.source} config validate
          touch $out
        '';
    in {
      checks = lib.mapAttrsToList borgmaticCheck configFiles;
    };
  };
}
