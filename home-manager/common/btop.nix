{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption concatStringsSep;
  inherit (lib.types) listOf str;
  # Black
  black0 = "#191D24";
  black1 = "#1E222A";
  black2 = "#222630";

  # Gray
  gray0 = "#242933";
  # Polar night
  gray1 = "#2E3440";
  gray2 = "#3B4252";
  gray3 = "#434C5E";
  gray4 = "#4C566A";
  # a light blue/gray
  # from @nightfox.nvim
  gray5 = "#60728A";

  # White
  # reduce_blue variant
  white0 = "#C0C8D8";
  # Snow storm
  white1 = "#D8DEE9";
  white2 = "#E5E9F0";
  white3 = "#ECEFF4";

  # Blue
  # Frost
  blue0 = "#5E81AC";
  blue1 = "#81A1C1";
  blue2 = "#88C0D0";

  # Cyan:
  cyan_base = "#8FBCBB";
  cyan_bright = "#9FC6C5";
  cyan_dim = "#80B3B2";

  # Aurora (from Nord theme)
  # Red
  red_base = "#BF616A";
  red_bright = "#C5727A";
  red_dim = "#B74E58";

  # Orange
  orange_base = "#D08770";
  orange_bright = "#D79784";
  orange_dim = "#CB775D";

  # Yellow
  yellow_base = "#EBCB8B";
  yellow_bright = "#EFD49F";
  yellow_dim = "#E7C173";

  # Green
  green_base = "#A3BE8C";
  green_bright = "#B1C89D";
  green_dim = "#97B67C";

  # Magenta
  magenta_base = "#B48EAD";
  magenta_bright = "#BE9DB8";
  magenta_dim = "#A97EA1";
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
        color_theme = "eldritch";
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
