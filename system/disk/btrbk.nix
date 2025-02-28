{
  lib,
  config,
  pkgs,
  user,
  isLaptop,
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
        default = "2h";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && isLaptop) {
      services.btrbk = {
        instances."remote_sakura" = {
          onCalendar = cfg.calendar;
          settings = {
            snapshot_preserve_min = "2d";
            snapshot_preserve = "2d 1w";
            target_preserve = "2d 1w";
            # NOTE: must be readable by user/group btrbk
            ssh_identity = "/home/${user}/.ssh/sakura";
            ssh_user = "btrbk";
            stream_compress = "lz4";
            volume."/" = {
              target = "ssh://192.168.68.62/media/acer-backups";
              subvolume = "persist";
            };
          };
        };
      };
    })

    (lib.mkIf (cfg.enable && isLaptop) {
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
