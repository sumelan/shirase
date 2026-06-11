{config, ...}: let
  inherit (config) flake;
  inherit (flake.custom.wrappers) mkSatty;
in {
  flake.custom.hjemConfigs.satty = {
    config,
    pkgs,
    user,
    ...
  }: let
    extraConfig = {
      general.output-filename = "${config.hjem.users.${user}.directory}/Pictures/Satty/%Y-%m-%d_%H-%M-%S.png";
    };
  in {
    hjem.users.${user} = {
      packages = [
        (mkSatty {inherit pkgs extraConfig;})
      ];

      xdg.mime-apps = let
        value = "satty.desktop";
        associations = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/png"
          ]);
      in {
        # remove `satty.desktop` from image mimetypes
        removed-associations = associations;
      };
    };
  };
}
