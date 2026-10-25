{
  self,
  pkgs,
  ...
}: {
  hjem.users.sumelan = {
    packages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.zathura
    ];

    xdg.mime-apps = let
      value = "org.pwmt.zathura-pdf-mupdf.desktop";
      removed-associations = builtins.listToAttrs (map (name: {
          inherit name value;
        }) [
          "image/jpeg"
          "image/gif"
          "image/webp"
          "image/png"
        ]);
    in {
      inherit removed-associations;
    };
  };
}
