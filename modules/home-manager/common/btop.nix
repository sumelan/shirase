{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption concatStringsSep;
  inherit (lib.types) listOf str;
in {
  options.custom = {
    btop.disks = mkOption {
      type = listOf str;
      default = [];
      description = "List of disks to monitor in btop";
    };
  };

  config = {
    home.shellAliases = {
      btop = "btop --preset 0";
    };

    programs.btop = {
      enable = true;
      settings = {
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
      };
    };
  };
}
