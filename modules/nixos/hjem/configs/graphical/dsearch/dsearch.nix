_: {
  flake.custom.hjemConfigs.dsearch = {
    config,
    pkgs,
    ...
  }: {
    hj = {
      xdg.config.files."danksearch/config.toml" = {
        generator = (pkgs.formats.toml {}).generate "config.toml";
        value = import ./_config.nix {inherit config;};
      };
    };
  };
}
