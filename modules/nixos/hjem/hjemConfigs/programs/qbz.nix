_: {
  flake.custom.hjemConfigs.qbz = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.qbz];
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
