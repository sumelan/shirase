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
        margin_right = 10;
        margin_bottom = 10;
        margin_left = 0;
        margin_top = 0;

        # Permits key bindings that conflict with compositor key bindings.
        # Default is `false`.
        inhibit_compositor_keyboard_shortcuts = true;

        # Try to guess the correct keyboard layout to use. Default is `false`.
        auto_kbd_layout = true;
      };
    in {
      "wlr-which-key/niri.yaml" = {
        source = (pkgs.formats.yaml {}).generate "niri" (settings
          // {
            menu = [
              {
                key = "c";
                desc = "Dynamic-cast";
                submenu = [
                  {
                    key = "w";
                    desc = "Select a window as the dynamic cast target";
                    cmd = "niri msg action set-dynamic-cast-window --id $(niri msg --json pick-window | jq .id)";
                  }
                  {
                    key = "o";
                    desc = "Set the dynamic cast target to the focuesd monitor";
                    cmd = "niri msg action set-dynamic-cast-monitor";
                  }
                  {
                    key = "c";
                    desc = "Clear the dynamic cast target";
                    cmd = "niri msg action clear-dynamic-cast-target";
                  }
                ];
              }
              {
                key = "s";
                desc = "Screenshot with annotation";
                submenu = [
                  {
                    key = "f";
                    desc = "Focused output";
                    cmd = "dms screenshot full --stdout | satty -f -";
                  }
                  {
                    key = "r";
                    desc = "Selected resion";
                    cmd = "dms screenshot --stdout | satty -f -";
                  }
                ];
              }
              {
                key = "d";
                desc = "DankMaterialShell";
                submenu = [
                  {
                    key = "c";
                    desc = "Open control center";
                    cmd = "dms ipc control-center toggle";
                  }
                  {
                    key = "d";
                    desc = "Open dashboard";
                    cmd = "dms ipc dash toggle '[tab]'";
                  }
                  {
                    key = "i";
                    desc = "Toggle idle-inhibitor";
                    cmd = "dms ipc inhibit toggle";
                  }
                  {
                    key = "l";
                    desc = "Toggle nightlight";
                    cmd = "dms ipc night toggle";
                  }
                  {
                    key = "n";
                    desc = "Open notepad";
                    cmd = "dms ipc call notepad toggle";
                  }
                ];
              }
            ];
          });
      };
    };
  };
}
