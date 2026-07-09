_: {
  flake.custom.hjemConfigs.noctalia = {
    pkgs,
    user,
    ...
  }: {
    # plugin dependencies
    hjem.users.${user} = {
      packages = builtins.attrValues {
        inherit (pkgs) mpvpaper;
      };
    };

    programs.gpu-screen-recorder.enable = true;

    custom.fileSystem = {
      cache.home.directories = [
        ".cache/noctalia"
      ];
    };
  };
}
