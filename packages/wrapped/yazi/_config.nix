{
  config,
  pkgs,
  ...
}: let
  inherit (config.flake.custom.lib.recursiveMerge {}) attrsList;
in
  attrsList [
    {
      plugins = {
        inherit
          (pkgs.yaziPlugins)
          full-border
          git
          yatline
          yatline-catppuccin
          yatline-githead
          ;
      };
      initLua =
        pkgs.writeText "init.lua"
        # lua
        ''
          require("full-border"):setup({ type = ui.Border.ROUNDED })
          require("git"):setup {
            -- Order of status signs showing in the linemode
           order = 1500,
          }
          require("yatline"):setup({ theme = require("yatline-catppuccin"):setup("frappe") })
          require("yatline-githead"):setup()
        '';

      flavors = let
        src = pkgs.fetchFromGitHub {
          owner = "yazi-rs";
          repo = "flavors";
          rev = "06708015bfb53b169d99bb3907829f9175105d57";
          hash = "sha256-Gm6ThktOLUR+KDs6f3s1WCgrw2TOKQ4tolVvVdCxnCM=";
        };
      in {
        catppuccin-frappe = "${src}/catppuccin-frappe.yazi";
      };

      settings = {
        yazi = {
          log = {
            enabled = true;
          };
          mgr = {
            ratio = [2 4 3];
            sort_by = "alphabetical";
            sort_sensitive = false;
            sort_reverse = false;
            linemode = "size";
            show_hidden = true;
          };
          opener = {
            # activate direnv before opening files
            # https://github.com/sxyazi/yazi/discussions/1083
            edit = [
              {
                run = "direnv exec . $EDITOR $1";
                block = true;
              }
            ];
          };

          # settings for plugins
          plugin = {
            prepend_fetchers = [
              {
                id = "git";
                url = "*";
                run = "git";
                group = "git";
              }
              {
                id = "git";
                url = "*/";
                run = "git";
                group = "git";
              }
            ];
          };
        };

        theme.flavor = {
          dark = "catppuccin-frappe";
        };

        keymap = {
          mgr.prepend_keymap = [
            # unar
            {
              on = ["u" "u"];
              run = ''shell -- unar "$@"'';
              desc = "Command-line unarchiver";
            }
            # pqiv
            {
              on = ["i" "p"];
              run = ''shell -- pqiv "$@"'';
              desc = "Open with pqiv";
            }
            # satty
            {
              on = ["i" "s"];
              run = ''shell -- satty -f "$@"'';
              desc = "Open with satty";
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
          ];
        };
      };
    }

    # browsing forwards and backwards in time through snapshots
    # https://github.com/iynaix/time-travel.yazi
    {
      plugins.time-travel = pkgs.yaziPlugins.time-travel;

      settings = {
        keymap.mgr.prepend_keymap = [
          {
            on = [
              "z"
              "h"
            ];
            run = "plugin time-travel prev";
            desc = "Go to previous snapshot";
          }
          {
            on = [
              "z"
              "l"
            ];
            run = "plugin time-travel next";
            desc = "Go to next snapshot";
          }
          {
            on = [
              "z"
              "e"
            ];
            run = "plugin time-travel exit";
            desc = "Exit browsing snapshots";
          }
        ];
      };
    }

    # smart-enter: enter for directory, open for file
    {
      plugins.smart-enter = pkgs.yaziPlugins.smart-enter;

      settings = {
        keymap.mgr.prepend_keymap = [
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
        ];
      };
    }

    # smart-paste: paste files without entering the directory
    {
      plugins.smart-paste = pkgs.yaziPlugins.smart-paste;

      settings = {
        keymap.mgr.prepend_keymap = [
          {
            on = "p";
            run = "plugin smart-paste";
            desc = "Paste into the hovered directory or CWD";
          }
        ];
      };
    }

    # lazygit: manage git repos with lazygit
    {
      plugins.lazygit = pkgs.yaziPlugins.lazygit;

      settings = {
        keymap.mgr.prepend_keymap = [
          {
            on = ["g" "i"];
            run = "plugin lazygit";
            desc = "Run lazygit";
          }
        ];
      };
    }
  ]
