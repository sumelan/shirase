{
  config,
  lib,
  ...
}: let
  inherit (config) flake;
in {
  flake.modules.nixos."hosts/sakura" = {
    config,
    pkgs,
    user,
    dotfile,
    ...
  }: let
    inherit
      (flake.custom.wrappers)
      mkNushell
      mkStarshipConfig
      ;
  in {
    hjem.users.${user}.rum = {
      programs.nushell = let
        extraConfig =
          # nu
          ''
            export-env { $env.GITHUB_TOKEN = '$(cat ${config.sops.secrets."github/sakura-token".path})' }

            # A `nix` and `nix-shell` wrapper for shells other than `bash`
            source ${
              pkgs.runCommand "nix-your-shell-nushell-config.nu" {} ''
                ${lib.getExe pkgs.nix-your-shell} --nom nu >> "$out"
              ''
            }
          '';

        extraRuntimeInputs = [pkgs.nix-your-shell];
      in {
        package = mkNushell {
          inherit pkgs extraConfig extraRuntimeInputs;
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
