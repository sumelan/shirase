_: {
  flake.custom.hjemConfigs.tuba = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.tuba];
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/tuba"
      ];
    };
  };
}
