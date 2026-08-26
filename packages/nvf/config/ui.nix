{lib, ...}: {
  flake.modules.nvf.ui = _: {
    vim = {
      comments.comment-nvim.enable = true;
      statusline.lualine.enable = true;
      tabline.nvimBufferline.enable = true;

      # Navigation
      projects.project-nvim.enable = true;
      navigation.harpoon.enable = true;

      mini = {
        notify.enable = true;
        icons.enable = true;
        cmdline.enable = true;
      };

      ui = {
        borders.enable = true;
        illuminate.enable = true;
        fastaction.enable = true;
        smartcolumn = {
          enable = true;
          setupOpts.custom_colorcolumn = {
            nix = "110";
            go = ["90" "130"];
            python = ["80" "120"];
          };
        };

        colorizer = {
          enable = true;
          setupOpts.filetypes = {
            "*" = {
              mode = "background";
              tailwind = true;
              names = true;
              RGB = true;
              RRGGBB = true;
            };
          };
        };
      };

      statusline.lualine.integrations = {
        breadcrumbs = {
          nvim-navic.enable = true;
          navbuddy.enable = true;
        };
      };

      visuals = {
        nvim-scrollbar.enable = true;
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;

        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        indent-blankline.enable = true;
        rainbow-delimiters = {
          enable = true;
          setupOpts =
            lib.generators.mkLuaInline
            # lua
            ''
              require("rainbow-delimiters.setup").setup {
                strategy = {
                  [""] = "rainbow-delimiters.strategy.global",
                  vim = "rainbow-delimiters.strategy.local",
                },
                query = {
                  [""] = "rainbow-delimiters",
                  lua = "rainbow-blocks",
                },
                highlight = {
                  "RainbowDelimiterRed",
                  "RainbowDelimiterYellow",
                  "RainbowDelimiterBlue",
                  "RainbowDelimiterOrange",
                  "RainbowDelimiterGreen",
                  "RainbowDelimiterViolet",
                  "RainbowDelimiterCyan",
                },
              }
            '';
        };
      };
    };
  };
}
