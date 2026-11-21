{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = [pkgs.foliate];
  };

  custom = {
    wayland.windowManager.niri.extraWindow-rule = [
      {
        match = [
          {_props.app-id._raw = ''r#"^com.github.johnfactotum.Foliate$"#'';}
        ];
        open-maximized = true;
        opacity = 1.000000;
      }
    ];

    fileSystem = {
      persist.home.directories = [
        ".local/share/com.github.johnfactotum.Foliate"
      ];

      cache.home.directories = [
        ".cache/com.github.johnfactotum.Foliate"
      ];
    };
  };
}
