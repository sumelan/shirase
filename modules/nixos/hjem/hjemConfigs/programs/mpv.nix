_: {
  flake.custom.hjemConfigs.webcord = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.mpv];

      xdg.mime-apps = {
        removed-associations = {
          "audio/ogg" = "umpv.desktop";
          "audio/flac" = "umpv.desktop";
          "video/mp4" = "umpv.desktop";
        };
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".local/state/mpv" # watch later
      ];
    };
  };
}
