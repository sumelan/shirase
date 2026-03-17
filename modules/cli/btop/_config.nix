{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) isBool isString;
  inherit (lib) concatStringsSep;
  inherit (lib.generators) mkKeyValueDefault toKeyValue;
in
  pkgs.writeText "btop.conf"
  (toKeyValue {
      mkKeyValue = mkKeyValueDefault {
        mkValueString = option:
          if isBool option
          then
            if option
            then "True"
            else "False"
          else if isString option
          then "\"${option}\""
          else toString option;
      } " = ";
    } {
      color_theme = "nord";
      theme_background = false;
      cpu_single_graph = true;
      show_disks = true;
      show_swap = true;
      swap_disk = false;
      use_fstab = false;
      only_physical = false;
      disks_filter = concatStringsSep " " (
        [
          "/"
          "/boot"
          "/persist"
        ]
        ++ config.custom.btop.disks
      );
    })
