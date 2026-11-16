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
}
