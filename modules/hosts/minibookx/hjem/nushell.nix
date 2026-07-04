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
      programs.nushell = let
        extraConfig =
          # nu
          ''
            export-env { $env.GITHUB_TOKEN = '$(cat ${config.sops.secrets."github/minibookx-token".path})' }
          '';
      in {
        package = mkNushell {
          inherit pkgs extraConfig;
          env = {
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
