{pkgs, ...}: {
  programs.kdeconnect = {
    enable = true;
    package = pkgs.valent; # kde-connect, but built with gtk
  };

  custom = {
    wayland.windowManager.niri.extraWindow-rule = [
      {
        match = [
          {_props.app-id._raw = ''r#"^valent$"#'';}
        ];
        open-floating = true;
      }
    ];

    fileSystem = {
      persist.home.directories = [
        ".config/valent"
      ];
      cache.home.directories = [
        ".cache/valent"
      ];
    };
  };
}
