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

      ssh_command = "ssh -i /home/sumelan/.ssh/borgbase";
      encryption_passcommand =
        # sh
        ''${lib.getExe pkgs.bitwarden-cli} get password Borgmatic --session 85iGC/4x6Uaj0BFy2wGOhteaK4uTKLmsC/LD9sAlM3kgKoADtlbHqxftw1Zef9RVgJb3GXYy2GSCSa+BsOGP2w=='';

      zfs = {
        zfs_command = lib.getExe config.boot.zfs.package;
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
                  path = "ssh://whcwf2xd@whcwf2xd.repo.borgbase.com/./repo";
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
                  path = "ssh://ynlt03ko@ynlt03ko.repo.borgbase.com/./repo";
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
