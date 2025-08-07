{
  lib,
  config,
  ...
}: {
  options.custom = {
    btop = {
      disks = lib.mkOption {
        type = with lib.types; listOf str;
        default = [];
        description = "List of disks to monitor in btop";
      };
    };
  };

  config = {
    home.shellAliases = {
      btop = "btop --preset 0";
    };

    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
        cpu_single_graph = true;
        show_disks = true;
        show_swap = true;
        swap_disk = false;
        use_fstab = false;
        only_physical = false;
        disks_filter = lib.concatStringsSep " " (
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
