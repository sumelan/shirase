{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/minibookx" = {
    config,
    pkgs,
    user,
    dotfile,
    ...
  }: let
    inherit (flake.custom.wrappers) mkNushell mkStarshipConfig;
  in {
    hjem.users.${user}.rum = {
      programs.nushell = {
        package = mkNushell {
          inherit pkgs;
          env = {
            GITHUB_TOKEN = config.sops.secrets."github/minibookx-token".path;
            NH_FLAKE = dotfile;
            NIXPKGS_ALLOW_UNFREE = "1";
            PAGER = "moor";
            STARSHIP_CONFIG = mkStarshipConfig {
              inherit pkgs;
              nf-icon = "󰟆 ";
            };
          };
        };
      };
    };
  };
}
