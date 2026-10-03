{lib, ...}: {
  flake.modules.nixos."hosts/sakura" = {
    config,
    pkgs,
    user,
    ...
  }: let
    conf = {
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

      ssh_command = "ssh -i /home/sumelan/.ssh/id_ed25519";

      encryption_passcommand =
        # sh
        ''${lib.getExe pkgs.bitwarden-cli} get password Borgmatic --session K67vnWDA1NsdsP93SmXylrLBPzqa0DcIBNChNcX2FJAe/yx7DKyiY4MDCDhBvgGMwvsyym3wJGny/Ern8/Y/PQ='';

      zfs = {
        zfs_command = lib.getExe config.boot.zfs.package;
        mount_command = lib.getExe' pkgs.unixtools.util-linux.out "mount";
        umount_command = lib.getExe' pkgs.unixtools.util-linux.out "umount";
      };
    };
  in {
    hjem.users.${user}.rum = {
      services.borgmatic = {
        enable = true;

        systemd = {
          enable = true;
          frequency = "daily";
        };

        configurations = {
          home =
            conf
            // {
              source_directories = [
                "/persist/home/sumelan/Documents"
                "/persist/home/sumelan/Music"
                "/persist/home/sumelan/Pictures"
                "/persist/home/sumelan/Videos"
              ];
              repositories = [
                {
                  label = "borgbase";
                  path = "ssh://h1sxd472@h1sxd472.repo.borgbase.com/./repo";
                }
              ];
            };

          audiobookshelf =
            conf
            // {
              source_directories = [
                "/persist/var/lib/audiobookshelf"
              ];
              repositories = [
                {
                  label = "borgbase";
                  path = "ssh://w6lisdrs@w6lisdrs.repo.borgbase.com/./repo";
                }
              ];
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
