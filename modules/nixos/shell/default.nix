{
  config,
  lib,
  ...
}: {
  flake.modules.nixos.default = {pkgs, ...}: let
    inherit (config.flake.packages.${pkgs.stdenv.hostPlatform.system}) nvf;
    inherit (config.flake.custom.userModules.shellAliases) basic extra;
  in {
    environment = {
      systemPackages = builtins.attrValues {
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
        # editor
        inherit nvf;
      };
      shellAliases = basic // extra;

      variables = {
        PAGER = "moor";
        SYSTEMD_PAGER = "moor";
        SYSTEMD_PAGERSECURE = "1";
        TERMINAL = "ghostty";
        EDITOR = "hx";
        VISUAL = "hx";
        NIXPKGS_ALLOW_UNFREE = "1";
      };
    };
  };
}
