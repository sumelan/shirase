{config, ...}: let
  inherit (config) flake;
in {
  flake.custom.hjemConfigs.zathura = {pkgs, ...}: let
    inherit (flake.packages.${pkgs.stdenv.hostPlatform.system}) zathura;
  in {
    hj = {
      packages = [zathura];

      xdg.mime-apps = let
        value = "org.pwmt.zathura-pdf-mupdf.desktop";
        associations = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/png"
          ]);
      in {
        removed-associations = associations;
      };
    };
  };
}
