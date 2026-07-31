_: {
  flake.custom.hjemConfigs.obs-studio = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.obs-studio];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/obs-studio"
      ];
    };
  };
}
