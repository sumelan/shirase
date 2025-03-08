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
  # https://xeiaso.net/blog/borg-backup-2021-01-09/
  options.custom.backup = {
    enable = mkEnableOption "backup";
    include = mkOption {
      type = with types; listOf str;
      default = [
        "/persist"
      ];
    };
    exclude = mkOption {
      type = with types; listOf str;
      default = [
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

    custom.persist = {
      root.directories = [
        "/root/borgbackup"
      ];
    };
  };
}
