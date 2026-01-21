{config, ...}: let
  inherit (config.flake.lib.colors) gray1 blue2 cyan_bright;
in {
  flake.modules.homeManager.default = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.custom.fonts) monospace;
  in {
    home.packages = [pkgs.wlr-which-key];

    xdg.configFile = let
      settings = {
        # Theming
        font = "${monospace} 14";
        background = gray1 + "d0";
        color = blue2;
        border = cyan_bright;
        separator = " ➜ ";
        border_width = 2;
        corner_r = 10;
        padding = 15; # Defaults to corner_r
        rows_per_column = 5; # No limit by default
        column_padding = 25; # Defaults to padding

        # Anchor and margin
        anchor = "bottom-right"; # One of center, left, right, top, bottom, bottom-left, top-left, etc.
        # Only relevant when anchor is not center
        margin_right = 5;
        margin_bottom = 5;
        margin_left = 0;
        margin_top = 0;

        # Permits key bindings that conflict with compositor key bindings.
        # Default is `false`.
        inhibit_compositor_keyboard_shortcuts = true;

        # Try to guess the correct keyboard layout to use. Default is `false`.
        auto_kbd_layout = true;
      };
    in {
      "wlr-which-key/application.yaml" = {
        source = (pkgs.formats.yaml {}).generate "application" (settings
          // {
            menu = [
              {
                key = "b";
                desc = "Browser";
                submenu = [
                  {
                    key = "l";
                    desc = "Librewolf";
                    cmd = "librewolf";
                  }
                  {
                    key = "h";
                    desc = "Helium";
                    cmd = "helium";
                  }
                ];
              }
              {
                key = "d";
                desc = "Discord";
                submenu = [
                  {
                    key = "v";
                    desc = "Vesktop";
                    cmd = "vesktop";
                  }
                ];
              }
              {
                key = "m";
                desc = "Music";
                submenu = [
                  {
                    key = "e";
                    desc = "Euphonica";
                    cmd = "euphonica";
                  }
                ];
              }
            ];
          });
      };
      "wlr-which-key/niri.yaml" = {
        source = (pkgs.formats.yaml {}).generate "niri" (settings
          // {
            menu = [
              {
                key = "d";
                desc = "󰗢 Dynamic-cast";
                submenu = [
                  {
                    key = "w";
                    desc = "Select a window as cast target";
                    cmd = "niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)";
                  }
                  {
                    key = "o";
                    desc = "Set current output as cast target";
                    cmd = "niri msg action set-dynamic-cast-monitor";
                  }
                  {
                    key = "c";
                    desc = "Clear cast target";
                    cmd = "niri msg action clear-dynamic-cast-target";
                  }
                ];
              }
            ];
          });
      };
    };
  };
}
