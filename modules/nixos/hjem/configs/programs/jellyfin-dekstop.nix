{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = [pkgs.jellyfin-desktop];
  };

  custom = {
    wayland.windowManager.niri.extraWindow-rule = [
      {
        match = [
          {_props.app-id._raw = ''r#"^org.jellyfin.JellyfinDesktop$"#'';}
        ];
        open-maximized = true;
        opacity = 1.000000;
      }
    ];

    fileSystem = {
      persist.home.directories = [
        ".local/share/jellyfin-desktop"
      ];

      cache.home.directories = [
        ".cache/jellyfin-desktop"
      ];
    };
  };
}
