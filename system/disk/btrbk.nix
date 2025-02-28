{
  lib,
  config,
  pkgs,
  host,
  user,
  isLaptop,
  isServer,
  ...
}:
let
  cfg = config.custom.btrbk;
in
{
  options.custom = with lib; {
    btrbk = {
      enable = mkEnableOption "filesystem snapshots using Btrbk";
      calendar = mkOption {
        type = types.str;
        default = "daily";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && isLaptop) {
      services.btrbk = {
        instances."remote_${host}" = {
          onCalendar = cfg.calendar;
          settings = {
            snapshot_preserve_min = "2d";
            snapshot_preserve = "14d";
            # NOTE: must be readable by user/group btrbk
            ssh_identity = "/home/${user}/.ssh/${host}";
            ssh_user = "btrbk";
            stream_compress = "lz4";
            volume."/" = {
              target = "btrbk@192.168.68.62:/mnt/wdelem4";
              subvolume = "persist";
            };
          };
        };
      };
    })

    (lib.mkIf (cfg.enable && isServer) {
      security.sudo = {
        extraRules = [{
          commands = [
            {
              command = "${pkgs.coreutils-full}/bin/test";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.coreutils-full}/bin/readlink";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.btrfs-progs}/bin/btrfs";
              options = [ "NOPASSWD" ];
            }
          ];
          users = [ "btrbk" ];
        }];
        extraConfig = with pkgs; ''
          Defaults:picloud secure_path="${lib.makeBinPath [
            btrfs-progs coreutils-full
          ]}:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
        '';
      };
      environment.systemPackages = [ pkgs.lz4 ];  
    })
  ];
}
