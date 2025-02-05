{
  lib,
  config,
  user,
  ...
}:
let
  cfg = config.custom.persist;
  hmPersistCfg = config.hm.custom.persist;
  assertNoHomeDirs =
    paths:
    assert (lib.assertMsg (!lib.any (lib.hasPrefix "/home") paths) "/home used in a root persist!");
    paths;
in
{
  options.custom = with lib; {
    persist = {
      root = {
        directories = mkOption {
          type = types.listOf types.str;
          default = [ ];
          apply = assertNoHomeDirs;
          description = "Directories to persist in root filesystem";
        };
        files = mkOption {
          type = types.listOf types.str;
          default = [ ];
          apply = assertNoHomeDirs;
          description = "Files to persist in root filesystem";
        };
      };
      home = {
        directories = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Directories to persist in home directory";
        };
        files = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Files to persist in home directory";
        };
      };
    };
  };

  config = {
    environment.persistence = {
      "/persist" = {
        hideMounts = true;
          files = lib.unique cfg.root.files;
          directories = lib.unique (
            [
              "/var/log" # systemd journal is stored in /var/log/journal
              "/var/lib/nixos" # for persisting user uids and gids
            ]
            ++ cfg.root.directories
          );

          users.${user} = {
          files = lib.unique (cfg.home.files ++ hmPersistCfg.home.files);
          directories = lib.unique (
            [
              "projects"
              ".cache/dconf"
              ".config/dconf"
            ]
            ++ cfg.home.directories
            ++ hmPersistCfg.home.directories
          );
        };
      };
    };

    # rollback results in sudo lectures after each reboot
    security.sudo.extraConfig = "Defaults lecture=never";

    hm.xdg.stateFile."impermanence.json".text =
      let
        getDirPath = prefix: d: "${prefix}${d.dirPath}";
        getFilePath = prefix: f: "${prefix}${f.filePath}";
        persistCfg = config.environment.persistence."/persist";
        allDirectories =
          map (getDirPath "/persist") (persistCfg.directories ++ persistCfg.users.${user}.directories);
        allFiles =
          map (getFilePath "/persist") (persistCfg.files ++ persistCfg.users.${user}.files);
        sort-uniq = arr: lib.sort lib.lessThan (lib.unique arr);
      in
      lib.strings.toJSON {
        directories = sort-uniq allDirectories;
        files = sort-uniq allFiles;
      };
  };
}
