{pkgs, ...}: {
  hjem.users.sumelan = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        protonmail-desktop
        proton-pass
        proton-vpn
        ;
    };
  };

  custom = {
    wayland.windowManager.niri.extraWindow-rule = [
      {
        match = [
          {_props.app-id._raw = ''r#"^Proton Mail$"#'';}
          {_props.app-id._raw = ''r#"^Proton Pass$"#'';}
          {_props.app-id._raw = ''r#"^.protonvpn-app-wrapped$"#'';}
        ];
        block-out-from = "screen-capture";
      }
    ];

    fileSystem = {
      persist.home.directories = [
        ".config/Proton"
        ".config/Proton Mail"
        ".config/Proton Pass"
      ];

      cache.home.directories = [
        ".cache/Proton"
      ];
    };
  };
}
