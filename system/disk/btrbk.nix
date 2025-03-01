{
  lib,
  config,
  pkgs,
  host,
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
      enable = mkEnableOption "snapshots using btrbk";
      calendar = mkOption {
        type = types.str;
        default = "daily";
      };
      preserve_min = mkOption {
        type = types.str;
        default = "3d";
      };
      preserve = mkOption {
        type = types.str;
        default = "7d";
      };
      target_preserve = mkOption {
        type = types.str;
        default = "7d";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.btrbk = lib.mkIf isLaptop {
      instances."remote_sakura" = {
        onCalendar = cfg.calendar;
        settings = {
          ssh_user = "btrbk";
          # NOTE: must be readable by user/group btrbk
          ssh_identity = "/etc/btrbk_key";
          snapshot_preserve_min = cfg.preserve_min;
          snapshot_preserve = cfg.preserve;
          target_preserve = cfg.target_preserve;
          stream_compress = "lz4";
          volume."/" = {
            target = "ssh://sakura/media/${host}-backups";
            subvolume = "persist";
          };
        };
      };
    };
    security.sudo = lib.mkIf isServer {
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
  };
}
