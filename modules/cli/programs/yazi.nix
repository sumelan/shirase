{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.default = {pkgs, ...}: {
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

    programs.yazi = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;

      plugins = {
        inherit
          (pkgs.yaziPlugins)
          chmod
          full-border
          git
          mount
          nord
          smart-paste
          starship
          time-travel
          toggle-pane
          yatline
          ;
      };

      flavors = {
        nord = flake.packages.${pkgs.stdenv.hostPlatform.system}.nord-yazi;
      };

      theme.flavor = {
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

          require("yatline"):setup()
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
            on = ["z" "h"];
            run = "plugin time-travel prev";
            desc = "Go to previous snapshot";
          }
          {
            on = ["z" "l"];
            run = "plugin time-travel next";
            desc = "Go to next snapshot";
          }
          {
            on = ["z" "e"];
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
            on = "<C-d>";
            run = ''shell -- ripdrag "$@" -x 2>/dev/null &'';
            desc = "Drag and Drop files";
          }
        ];
      };
    };
  };
}
