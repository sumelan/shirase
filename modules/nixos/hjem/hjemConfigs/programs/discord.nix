_: {
  flake.custom.hjemConfigs.discord = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [
        pkgs.concord-tui
        pkgs.webcord-vencord
      ];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/WebCord"
      ];
    };
  };
}
