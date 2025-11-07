{pkgs, ...}: {
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
          yatline
          starship
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
          {
            on = "M";
            run = "plugin mount";
            desc = "Open mount";
          }
          {
            on = "T";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Chmod on selected files";
          }
          {
            on = ["g" "g"];
            run = "plugin lazygit";
            desc = "run lazygit";
          }
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
          action.spawn = ["foot" "--app-id=yazi" "yazi"];
          hotkey-overlay.title = ''<span foreground="#EFD49F">[ yazi]</span> Terminal File manager'';
        };
      };
    };
  };
}
