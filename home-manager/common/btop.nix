{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption concatStringsSep;
  inherit (lib.types) listOf str;

  base00 = "#323449";
  base01 = "#212337";
  base05 = "#ebfafa";
  base06 = "#7081d0";
  base09 = "#f16c75";
  base0A = "#04d1f9";
  base0B = "#37f499";
  base0C = "#f7c67f";
  base0E = "#a48cf2";
  base0F = "#f1fc79";
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
      themes.eldritch = ''
        theme[main_bg]="${base00}"
        theme[main_fg]="${base05}"
        theme[title]="${base05}"
        theme[hi_fg]="${base0F}"
        theme[selected_bg]="${base01}"
        theme[selected_fg]="${base0F}"
        theme[inactive_fg]="${base05}"
        theme[graph_text]="${base06}"
        theme[meter_bg]="${base01}"
        theme[proc_misc]="${base06}"
        theme[cpu_box]="${base0E}"
        theme[mem_box]="${base0B}"
        theme[net_box]="${base0C}"
        theme[proc_box]="${base0F}"
        theme[div_line]="${base01}"
        theme[temp_start]="${base0B}"
        theme[temp_mid]="${base0A}"
        theme[temp_end]="${base06}"
        theme[cpu_start]="${base0B}"
        theme[cpu_mid]="${base0A}"
        theme[cpu_end]="${base06}"
        theme[free_start]="${base0A}"
        theme[free_mid]="${base0B}"
        theme[free_end]="${base0B}"
        theme[cached_start]="${base0C}"
        theme[cached_mid]="${base0C}"
        theme[cached_end]="${base0A}"
        theme[available_start]="${base06}"
        theme[available_mid]="${base0A}"
        theme[available_end]="${base0B}"
        theme[used_start]="${base0A}"
        theme[used_mid]="${base09}"
        theme[used_end]="${base06}"
        theme[download_start]="${base0B}"
        theme[download_mid]="${base0A}"
        theme[download_end]="${base06}"
        theme[upload_start]="${base0B}"
        theme[upload_mid]="${base0A}"
        theme[upload_end]="${base06}"
        theme[process_start]="${base0B}"
        theme[process_mid]="${base0A}"
        theme[process_end]="${base06}"
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
