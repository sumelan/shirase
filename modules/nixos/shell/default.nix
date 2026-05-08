{
  config,
  lib,
  ...
}: {
  flake.modules.nixos.default = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) nvf;
    inherit (config.flake.custom.userModules.shellAliases) basic extra fish;
  in {
    environment = {
      systemPackages = builtins.attrValues {
        inherit nvf;
        inherit
          (pkgs)
          bonk # mkdir and touch in one
          curl
          dysk # better disk info
          ets # add timestamp to beginning of each line
          fd # better find
          fx # terminal json viewer and processor
          gzip
          htop
          jq
          just
          killall
          microfetch
          procs # better ps
          sd # better sed
          trash-cli
          ugrep # grep, with boolean query patterns, e.g. ug --files -e "A" --and "B"
          xdg-utils
          ;
        inherit (lib.hiPrio pkgs) procps;
      };
      shellAliases = basic // extra // fish;

      variables = {
        TERMINAL = "ghostty";
        EDITOR = "nvim";
        VISUAL = "nvim";
        NIXPKGS_ALLOW_UNFREE = "1";
      };
    };
  };
}
