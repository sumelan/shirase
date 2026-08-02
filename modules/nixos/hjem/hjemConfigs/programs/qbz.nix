_: {
  flake.custom.hjemConfigs.qbz = {user, ...}: {
    hjem.users.${user} = {
      rum = {
        programs.qbz = {
          enable = true;
        };
      };
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/qbz"
        ".local/share/qbz"
      ];

      cache.home.directories = [
        ".cache/qbz"
      ];
    };
  };
}
