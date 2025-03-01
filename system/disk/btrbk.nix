{
  lib,
  config,
  pkgs,
  host,
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

  config = lib.mkIf (cfg.enable && isLaptop) {
    services.btrbk = {
      sshAccess = [{
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA90FlIi09fQX3QfmscjCGLLwrL1z8xnnxXRhZ4pjHU3 sumelan";
        roles = [
          "source"
          "info"
          "delete"
          "send"
        ];
      }];
      instances."remote_sakura" = {
        onCalendar = cfg.calendar;
        settings = {
          snapshot_preserve_min = cfg.preserve_min;
          snapshot_preserve = cfg.preserve;
          target_preserve = cfg.target_preserve;
          stream_compress = "lz4";
          volume."/" = {
            target = "ssh://192.168.68.62/media/${host}-backups";
            subvolume = "persist";
          };
        };
      };
    };
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
        users = [ "${user}" ];
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
