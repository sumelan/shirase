{
  config,
  pkgs,
  ...
}: let
  mkYaziPlugin = name: text: {
    "${name}" = toString (pkgs.writeTextDir "${name}.yazi/main.lua" text) + "/${name}.yazi";
  };
in
  config.flake.lib.recursiveMergeAttrsList [
    {
      plugins = {
        inherit
          (pkgs.yaziPlugins)
          full-border
          git
          time-travel
          yatline
          ;
        # patched plugins
        inherit (pkgs) nord-yazi;
      };
      initLua =
        pkgs.writeText "init.lua"
        # lua
        ''
          require("full-border"):setup({ type = ui.Border.ROUNDED })
          require("git"):setup()
          require("yatline"):setup({
            theme = require("nord-yazi"):setup(),

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
      plugins.time-travel = pkgs.fetchFromGitHub {
        owner = "iynaix";
        repo = "time-travel.yazi";
        rev = "aaec6e26e525bd146354a5137ec40f1f23257a4e";
        hash = "sha256-/+KiuGUox763dMQvHl1l3+Ci3vL8NwRuKNu9pi3gjyE=";
      };

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
    # https://yazi-rs.github.io/docs/tips/#smart-enter
    {
      plugins = mkYaziPlugin "smart-enter" ''
        --- @sync entry
        return {
        	entry = function()
            local h = cx.active.current.hovered
            ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
          end,
        }
      '';
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
    # https://yazi-rs.github.io/docs/tips/#smart-enter
    {
      plugins = mkYaziPlugin "smart-paste" ''
        --- @sync entry
        return {
          entry = function()
            local h = cx.active.current.hovered
            if h and h.cha.is_dir then
              ya.manager_emit("enter", {})
              ya.manager_emit("paste", {})
              ya.manager_emit("leave", {})
            else
              ya.manager_emit("paste", {})
            end
          end,
        }
      '';
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

    # arrow: file navigation wraparound
    {
      plugins = mkYaziPlugin "arrow" ''
        --- @sync entry
        return {
          entry = function(_, job)
            local current = cx.active.current
            local new = (current.cursor + job.args[1]) % #current.files
            ya.manager_emit("arrow", { new - current.cursor })
          end,
        }
      '';
      settings = {
        keymap.mgr.prepend_keymap = [
          {
            on = "k";
            run = "plugin arrow -1";
          }
          {
            on = "j";
            run = "plugin arrow 1";
          }
        ];
      };
    }
  ]
