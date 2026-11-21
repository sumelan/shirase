{
  self,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) genAttrs;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) pqiv;
in {
  hjem.users.sumelan = {
    packages = [
      pqiv
    ];

    xdg.mime-apps.removed-associations = genAttrs [
      "video/mp4"
    ] (_: "pqiv.desktop");
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
