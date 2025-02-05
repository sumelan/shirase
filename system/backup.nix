{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.custom.backup;
in
{
  options.custom.backup = {
    enable = mkEnableOption "Enable borgbackupjob";
    include = mkOption {
      type = with types; listOf str;
      default = [
        "/var/lib"
        "/srv"
        "/home"
      ];
    };
    exclude = mkOption {
      type = with types; listOf str;
      default = [
        # very large paths
        "/var/lib/docker"
        "/var/lib/systemd"
        "/var/lib/libvirt"
      ];
    };
    repo = mkOption {
      type = types.str;
      default = "";
    };
    cycle = mkOption {
      type = types.str;
      default = "daily";
    };
  };

  config = mkIf cfg.enable {
    services.borgbackup.jobs."borgbase" = {
      paths = cfg.include;
      exclude = cfg.exclude;
      repo = "${cfg.repo}";
      encryption = {
        mode = "repokey-blake2";
        passCommand = "cat /root/borgbackup/passphrase";
      };
      environment.BORG_RSH = "ssh -i /root/borgbackup/ssh_key";
      compression = "auto,lzma";
      startAt = "${cfg.cycle}";
    };
  };
}
