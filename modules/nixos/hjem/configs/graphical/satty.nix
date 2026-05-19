{config, ...}: let
  inherit (config) flake;
  inherit (flake.custom.wrappers) mkSatty;
in {
  flake.custom.hjemConfigs.satty = {
    config,
    pkgs,
    ...
  }: let
    extraConfig = {
      general.output-filename = "${config.hj.directory}/Pictures/Satty/%Y-%m-%d_%H-%M-%S.png";
    };
  in {
    hj = {
      packages = [
        (mkSatty {inherit pkgs extraConfig;})
      ];

      xdg.mime-apps = let
        value = "satty.desktop";
        associations = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "image/*"
          ]);
      in {
        # remove `satty.desktop` from image mimetypes
        removed-associations = associations;
      };
    };
  };
}
