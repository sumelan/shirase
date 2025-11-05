{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption concatStringsSep;
  inherit (lib.types) listOf str;
  inherit
    (lib.custom.colors)
    gray0
    gray1
    white3
    blue0
    blue2
    yellow_base
    yellow_bright
    cyan_dim
    cyan_base
    cyan_bright
    red_dim
    red_base
    red_bright
    green_dim
    green_base
    green_bright
    orange_base
    orange_bright
    magenta_dim
    magenta_base
    magenta_bright
    ;
in {
  options.custom = {
    btop = {
      disks = mkOption {
        type = listOf str;
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
      themes.nord = ''
        theme[main_bg]="${gray0}"
        theme[main_fg]="${white3}"
        theme[title]="${white3}"
        theme[hi_fg]="${orange_bright}"
        theme[selected_bg]="${gray1}"
        theme[selected_fg]="${orange_bright}"
        theme[inactive_fg]="${white3}"
        theme[graph_text]="${cyan_bright}"
        theme[meter_bg]="${gray1}"
        theme[proc_misc]="${orange_bright}"
        theme[cpu_box]="${magenta_base}"
        theme[mem_box]="${green_base}"
        theme[net_box]="${yellow_base}"
        theme[proc_box]="${orange_bright}"
        theme[div_line]="${gray1}"
        theme[temp_start]="${blue0}"
        theme[temp_mid]="${orange_base}"
        theme[temp_end]="${red_bright}"
        theme[cpu_start]="${blue2}"
        theme[cpu_mid]="${green_base}"
        theme[cpu_end]="${yellow_bright}"
        theme[free_start]="${green_dim}"
        theme[free_mid]="${green_base}"
        theme[free_end]="${green_bright}"
        theme[cached_start]="${red_dim}"
        theme[cached_mid]="${red_base}"
        theme[cached_end]="${red_bright}"
        theme[available_start]="${green_bright}"
        theme[available_mid]="${green_base}"
        theme[available_end]="${green_dim}"
        theme[used_start]="${magenta_bright}"
        theme[used_mid]="${magenta_base}"
        theme[used_end]="${magenta_dim}"
        theme[download_start]="${cyan_bright}"
        theme[download_mid]="${cyan_base}"
        theme[download_end]="${cyan_dim}"
        theme[upload_start]="${green_bright}"
        theme[upload_mid]="${green_base}"
        theme[upload_end]="${green_dim}"
        theme[process_start]="${cyan_dim}"
        theme[process_mid]="${yellow_base}"
        theme[process_end]="${red_bright}"
      '';

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
