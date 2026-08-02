_: {
  flake.custom.hjemConfigs.webcord = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.webcord-vencord];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/WebCord"
      ];
    };
  };
}
