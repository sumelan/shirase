{pkgs, ...}: {
  hjem.users.sumelan = {
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

  custom = {
    wayland.windowManager.niri.extraWindow-rule = [
      {
        match = [
          {_props.app-id._raw = ''r#"^mpv$"#'';}
        ];
        default-column-width._children = [
          {proportion = 0.450000;}
        ];
        default-window-height._children = [
          {proportion = 0.450000;}
        ];
        open-floating = true;
        opacity = 1.000000;
      }
    ];

    fileSystem = {
      cache.home.directories = [
        ".local/state/mpv" # watch later
      ];
    };
  };
}
