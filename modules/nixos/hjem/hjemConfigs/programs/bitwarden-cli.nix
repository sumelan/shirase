_: {
  flake.custom.hjemConfigs.bitwarden-cli = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.bitwarden-cli];
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/Bitwarden CLI"
      ];
    };
  };
}
