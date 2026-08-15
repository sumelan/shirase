{
  inputs,
  lib,
  ...
}: {
  flake.modules.nvf.dashboard-alpha = {pkgs, ...}: let
    logo = import ./_logo.nix {inherit pkgs;};

    press = command:
      lib.generators.mkLuaInline
      # lua
      ''
        function()
          vim.cmd("${command}")
        end
      '';

    keymap = key: command: [
      "n"
      "${key}"
      "<cmd>${command}<CR>"
      {
        noremap = true;
        silent = true;
        nowait = true;
      }
    ];

    ttfCmd = lib.concatStringsSep " " [
      (lib.getExe inputs.ttf.packages.${pkgs.stdenv.hostPlatform.system}.default)
      "--no-color"
      "--anchor-canvas s"
      "slide"
      "--merge --movement-speed 0.8"
      "--final-gradient-direction diagonal"
    ];
  in {
    vim = {
      dashboard.alpha = {
        enable = true;
        theme = null;

        opts = {
          setup =
            lib.generators.mkLuaInline
            # lua
            ''
              function ()
                require("alpha.term")
              end
            '';
        };

        layout = [
          {
            type = "padding";
            val = 2;
          }
          {
            type = "terminal";
            command =
              # sh
              ''cat ${logo} | ${ttfCmd}'';
            width = 80;
            height = 10;
            opts = {
              redraw = true;
            };
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "group";
            val = [
              {
                type = "button";
                val = " New File";
                on_press = press "ene | startinsert";
                opts = {
                  position = "center";
                  shortcut = "n";
                  keymap = keymap "n" "ene | startinsert";
                  cursor = 3;
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = " Find File";
                on_press = press "Telescope find_files";
                opts = {
                  position = "center";
                  shortcut = "f";
                  keymap = keymap "f" "Telescope find_files";
                  cursor = 3;
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = " Find Text";
                on_press = press "Telescope live_grep";
                opts = {
                  position = "center";
                  shortcut = "g";
                  keymap = keymap "g" "Telescope live_grep";
                  cursor = 3;
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = " Recent Files";
                on_press = press "Telescope oldfiles";
                opts = {
                  position = "center";
                  shortcut = "r";
                  keymap = keymap "r" "Telescope oldfiles";
                  cursor = 3;
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = " Check Config";
                on_press = press "checkhealth";
                opts = {
                  position = "center";
                  shortcut = "h";
                  keymap = keymap "h" "checkhealth";
                  cursor = 3;
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
              {
                type = "button";
                val = " Quit";
                on_press = press "qa";
                opts = {
                  position = "center";
                  shortcut = "q";
                  keymap = keymap "q" "qa";
                  cursor = 3;
                  width = 50;
                  align_shortcut = "right";
                  hl_shortcut = "Keyword";
                };
              }
            ];

            opts = {
              spacing = 1;
              position = "center";
              hl = "Function";
            };
          }
        ];
      };

      spellcheck.ignoredFiletypes = ["alpha"];
    };
  };
}
