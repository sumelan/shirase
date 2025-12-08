{
  lib,
  pkgs,
  ...
}: let
  inherit (lib.custom.colors) yellow_bright;
  inherit (lib.custom.niri) spawn hotkey;
in {
  home = {
    packages = builtins.attrValues {
      inherit
        (pkgs)
        ripdrag # Drag and Drop utilty written in Rust and GTK4
        unar
        exiftool
        ;
    };

    shellAliases = {
      lf = "yazi";
      y = "yazi";
    };
  };

  programs = {
    yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;

      plugins = {
        inherit
          (pkgs.yaziPlugins)
          chmod
          git
          lazygit
          nord
          starship
          time-travel
          yatline
          ;

        # defined in `packages/yazi-plugins`
        full-border = "${pkgs.custom.yazi-plugins.src}/full-border.yazi";
        toggle-pane = "${pkgs.custom.yazi-plugins.src}/toggle-pane.yazi";
        mount = "${pkgs.custom.yazi-plugins.src}/mount.yazi";
      };

      flavors = {inherit (pkgs.yaziPlugins) nord;};

      theme.flavor = {
        light = "nord";
        dark = "nord";
      };

      initLua =
        #lua
        ''
          require("full-border"):setup({ type = ui.Border.ROUNDED })

          require("git"):setup()

          require("starship"):setup({
            -- Custom starship configuration file to use
            config_file = "~/.config/starship.toml",
          })

          require("yatline"):setup({
            theme = require("nord"):setup(),
          })
        '';

      settings = {
        log.enabled = true;
        mgr = {
          ratio = [0 1 1];
          sort_by = "alphabetical";
          sort_sensitive = false;
          sort_reverse = false;
          linemode = "size";
          show_hidden = true;
        };
        opener = {};
        # settings for plugins
        plugin = {
          prepend_fetchers = [
            {
              id = "git";
              name = "*";
              run = "git";
            }
            {
              id = "git";
              name = "*/";
              run = "git";
            }
          ];
        };
      };
      keymap = {
        mgr.prepend_keymap = [
          # chmod
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Run chmod on selected files";
          }
          # lazygit
          {
            on = ["g" "g"];
            run = "plugin lazygit";
            desc = "Run lazygit";
          }
          # mount
          {
            on = "M";
            run = "plugin mount";
            desc = "Open mount";
          }
          # time-travel
          {
            on = ["b" "h"];
            run = "plugin time-travel prev";
            desc = "Go to previous snapshot";
          }
          {
            on = ["b" "l"];
            run = "plugin time-travel next";
            desc = "Go to next snapshot";
          }
          {
            on = ["b" "e"];
            run = "plugin time-travel exit";
            desc = "Exit browsing snapshots";
          }
          # toggle-pane
          {
            on = "T";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
          # ripdrag
          {
            on = "<C-n>";
            run = "shell --confirm 'ripdrag \"$@\" -x 2>/dev/null &'";
          }
        ];
      };
    };

    niri.settings = {
      binds = {
        "Mod+Shift+O" = {
          action.spawn = spawn "ghostty -e yazi";
          hotkey-overlay.title = hotkey {
            color = yellow_bright;
            name = "  yazi";
            text = "Terminal File Manager";
          };
        };
      };
    };
  };
}
