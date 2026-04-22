{inputs, ...}: {
  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: {
    programs.dsearch = {
      enable = true;
      package = inputs.dsearch.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
