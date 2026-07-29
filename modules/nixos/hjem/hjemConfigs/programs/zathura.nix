{config, ...}: {
  flake.custom.hjemConfigs.zathura = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    hjem.users.${user} = {
      packages = [local.zathura];

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
  };
}
