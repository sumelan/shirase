_: {
  flake.custom.hjemConfigs.readest = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.readest];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/com.bilingify.readest"
      ];

      cache.home.directories = [
        ".cache/com.bilingify.readest"
        ".local/share/com.bilingify.readest"
      ];
    };
  };
}
