_: let
  inherit (builtins) attrValues;
in {
  flake.modules.homeManager.default = {pkgs, ...}: {
    home = {
      packages = attrValues {
        inherit
          (pkgs)
          ripdrag # Drag and Drop utilty written in Rust and GTK4
          unar # archive unpacker program
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
      shellWrapperName = "y";
      plugins = {
        inherit
          (pkgs.yaziPlugins)
          chmod
          full-border
          mount
          smart-paste
          starship
          time-travel
          toggle-pane
          yatline
          ;
        # patched plugins
        inherit (pkgs) nord;
      };

      flavors = {inherit (pkgs) nord;};

      theme.flavor = {
        light = "nord";
        dark = "nord";
      };

      initLua =
        #lua
        ''
          require("full-border"):setup {
              type = ui.Border.ROUNDED
          }

          require("starship"):setup({
              -- Custom starship configuration file to use
              config_file = "~/.config/starship.toml",
          })

          require("yatline"):setup({
              theme = require("nord"):setup(),

              padding = { inner = 1, outer = 1 },
              tab_width = 20,

              show_background = false,

              display_header_line = true,
              display_status_line = true,

              component_positions = { "header", "tab", "status" },

              header_line = {
                  left = {
                      section_a = {
                          {type = "line", custom = false, name = "tabs", params = {"left"}},
                      },
                      section_b = {},
                      section_c = {},
                  },
                  right = {
                      section_a = {
                          {type = "string", custom = false, name = "date", params = {"%A, %d %B %Y"}},
                      },
                      section_b = {
                          {type = "string", custom = false, name = "date", params = {"%X"}},
                      },
                      section_c = {},
                  },
              },

              status_line = {
                  left = {
                      section_a = {
                          {type = "string", custom = false, name = "tab_mode"},
                      },
                      section_b = {
                          {type = "string", custom = false, name = "hovered_size"},
                      },
                      section_c = {
                          {type = "string", custom = false, name = "hovered_path"},
                          {type = "coloreds", custom = false, name = "count"},
                      },
                  },
                  right = {
                      section_a = {
                          {type = "string", custom = false, name = "cursor_position"},
                      },
                      section_b = {
                          {type = "string", custom = false, name = "cursor_percentage"},
                      },
                      section_c = {
                          {type = "string", custom = false, name = "hovered_file_extension", params = {true}},
                          {type = "coloreds", custom = false, name = "permissions"},
                      },
                  },
              },
          })
        '';

      settings = {
        log.enabled = true;
        mgr = {
          ratio = [2 4 3];
          sort_by = "alphabetical";
          sort_sensitive = false;
          sort_reverse = false;
          linemode = "size";
          show_hidden = true;
        };
        opener = {};
      };
      keymap = {
        mgr.prepend_keymap = [
          # chmod
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "Run chmod on selected files";
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
          # mount
          {
            on = "M";
            run = "plugin mount";
            desc = "Open mount";
          }
          # toggle-pane
          {
            on = "T";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
          # unar
          {
            on = ["u" "u"];
            run = ''shell -- unar "$@"'';
            desc = "Command-line unarchiver";
          }
          # satty
          {
            on = ["i" "a"];
            run = ''shell -- satty -f "$@"'';
            desc = "Annotate image(s) with satty";
          }
          # ripdrag
          {
            on = ["i" "d"];
            run = ''shell -- ripdrag --no-click --and-exit --icon-size 64 --target --all "$@" | while read filepath; do cp -nR "$filepath" .; done'';
            desc = "Drag-n-drop files from and to Yazi";
          }
          {
            on = ["i" "D"];
            run = ''shell -- ripdrag --no-click --and-exit --icon-size 64 --target --all "$@" | while read filepath; do cp -fR "$filepath" .; done'';
            desc = "Drag-n-drop files to and from Yazi";
          }
          # swayimg
          {
            on = ["i" "o"];
            run = ''shell -- swayimg "$@"'';
            desc = "Open image(s) with swayimg";
          }
        ];
      };
    };
  };
}
