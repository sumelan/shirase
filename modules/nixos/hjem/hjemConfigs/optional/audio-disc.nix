_: {
  flake.custom.hjemConfigs.audio-disc = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [
        pkgs.cyanrip
        pkgs.picard
      ];
    };
  };
}
