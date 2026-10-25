{
  self,
  pkgs,
  ...
}: {
  hjem.users.sumelan = {
    packages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.pqiv
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
