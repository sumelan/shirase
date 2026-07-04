{lib, ...}: {
  flake.custom.hjemConfigs.noctalia = {user, ...}: {
    hjem.users.${user} = {
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = lib.importTOML ./settings.toml;
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/noctalia"
        ".local/state/noctalia"
      ];
    };
  };
}
