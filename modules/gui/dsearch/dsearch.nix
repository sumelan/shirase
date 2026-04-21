_: {
  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: {
    programs.dsearch = {
      enable = true;
      systemd.enable = true;
    };

    hj = {
      xdg.config.files."danksearch/config.toml" = {
        generator = (pkgs.formats.toml {}).generate "config.toml";
        value = import ./_config.nix {inherit config;};
      };
    };
  };
}
