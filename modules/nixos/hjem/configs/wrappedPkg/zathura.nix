{
  self,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) genAttrs;
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) zathura;
in {
  hjem.users.sumelan = {
    packages = [
      zathura
    ];

    xdg.mime-apps.removed-associations = genAttrs [
      "image/jpeg"
      "image/gif"
      "image/webp"
      "image/png"
    ] (_: "org.pwmt.zathura-pdf-mupdf.desktop");
  };
}
