{
  self,
  pkgs,
  ...
}: let
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) pqiv;
in {
  hjem.users.sumelan = {
    packages = [
      pqiv
    ];

    xdg.mime-apps = let
      value = "pqiv.desktop";
      removed-associations = builtins.listToAttrs (map (name: {
          inherit name value;
        }) [
          "video/mp4"
        ]);
    in {
      inherit removed-associations;
    };
  };

  custom.wayland.windowManager.niri.extraWindow-rule = [
    {
      match = [
        {_props.app-id._raw = ''r#"^pqiv$"#'';}
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
}
