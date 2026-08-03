_: {
  flake.custom.hjemConfigs.discord = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.vesktop];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/vesktop"
      ];
    };
  };
}
