{config, ...}: {
  flake.custom.hjemConfigs.pqiv = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    hjem.users.${user} = {
      packages = [local.pqiv];

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
  };
}
