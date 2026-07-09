_: {
  flake.custom.hjemConfigs.noctalia = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      # plugin dependencies
      packages = builtins.attrValues {
        inherit
          (pkgs)
          mpvpaper
          gpu-screen-recorder
          ;
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/noctalia"
      ];
    };
  };
}
