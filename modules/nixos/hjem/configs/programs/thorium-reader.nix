{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = [pkgs.thorium-reader];
  };

  custom = {
    wayland.windowManager.niri.extraWindow-rule = [
      {
        match = [
          {_props.app-id._raw = ''r#"^edrlab-thoriumreader$"#'';}
        ];
        opacity = 1.000000;
      }
    ];

    fileSystem = {
      persist.home.directories = [
        ".config/EDRLab.ThoriumReader"
      ];
    };
  };
}
