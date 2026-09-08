_: {
  flake.custom.hjemConfigs.mpv = {
    pkgs,
    user,
    ...
  }: {
    hjem.users.${user} = {
      packages = [pkgs.mpv];

      xdg.mime-apps = let
        value = "umpv.desktop";
        removed-associations = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "audio/mp4"
            "audio/mpeg"
            "audio/ogg"
            "audio/flac"
            "video/mp4"
            "video/mpeg"
            "video/webm"
          ]);
      in {
        inherit removed-associations;
      };
    };

    custom.fileSystem = {
      cache.home.directories = [
        ".local/state/mpv" # watch later
      ];
    };
  };
}
