{
  inputs,
  lib,
  ...
}: let
  inherit (lib) getExe mkForce;
in {
  flake.modules = {
    nixos.default = {
      config,
      pkgs,
      ...
    }: let
      nord = pkgs.fetchFromGitHub {
        owner = "connorholyday";
        repo = "nord-kitty";
        rev = "3a819c1f207cd2f98a6b7c7f9ebf1c60da91c9e9";
        hash = "sha256-Zbmrp2sQO0upkQ6Gtt5O4SLzPhovUDQNjvM0x8v2a0g=";
      };
      fishPath = getExe config.programs.fish.package;
    in {
      nixpkgs.overlays = [
        (_: prev: {
          kitty =
            (inputs.wrappers.wrapperModules.kitty.apply {
              pkgs = prev;
              settings = {
                include = "${nord}/nord.conf";

                allow_remote_control = "yes";
                bold_font = "auto";
                bold_italic_font = "auto";
                copy_on_select = "yes";
                cursor_blink_interval = "0.5";
                cursor_shape = "block";
                cursor_stop_blinking_after = "15.0";
                cursor_trail = 3;
                cursor_trail_start_threshold = 10;
                enable_audio_bell = "no";
                enabled_layouts = "fat:bias=75;full_size=1;mirrored=false";
                env = "SHELL=${fishPath}";
                font_family = "Maple Mono NF";
                font_size = 14;
                initial_window_height = "768";
                initial_window_width = "1024";
                italic_font = "auto";
                mouse_map = "left click ungrabbed,grabbed mouse_select_command";
                remember_window_size = "yes";
                scrollback_lines = "10000";
                shell = mkForce fishPath;
                strip_trailing_spaces = "smart";
                tab_bar_style = "powerline";
                tab_powerline_style = "slanted";
                url_style = "single";
                visual_bell_duration = "0.1";
                window_padding_width = "10";
              };
            }).wrapper;
        })
      ];
    };

    homeManager.default = {pkgs, ...}: {
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/terminal" = "kitty.desktop";
      };

      home = {
        packages = [
          pkgs.kitty # overlay-ed above
        ];
        shellAliases = {
          # change color on ssh
          ssh = "kitten ssh --kitten=color_scheme='Rosé Pine Moon'";
        };
      };

      custom.programs = {
        print-config = {
          kitty =
            # sh
            ''cat "${pkgs.kitty.flags."--config"}"'';
        };
      };
    };
  };
}
