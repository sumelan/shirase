{
  lib,
  config,
  inputs,
  host,
  flakePath,
  ...
}:
{
  imports = [ inputs.nvf.homeManagerModules.default ];

  programs.nvf = lib.mkIf config.custom.neovim.enable {
    enable = true;
    settings.vim = {
      lsp.enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      lineNumberMode = "relNumber";
      enableLuaLoader = true;
      preventJunkFiles = true;

      options = {
        cursorlineopt = "line";
        autoindent = true;
        tabstop = 4;
        shiftwidth = 2;
        wrap = false;
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers = {
          wl-copy.enable = true;
          xsel.enable = true;
        };
      };

      maps = {
        normal = {
          "<leader>e" = {
            action = "<CMD>Neotree toggle<CR>";
            silent = false;
          };
        };
      };

      diagnostics = {
        enable = true;
        config = {
          virtual_lines.enable = true;
          underline = true;
        };
      };

      telescope.enable = true;

      lsp = {
        formatOnSave = true;
        lspkind.enable = true;
        trouble.enable = true;
        otter-nvim.enable = true;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        bash.enable = true;

        nix = {
          enable = true;
          format.type = "alejandra";
          lsp = {
            enable = true;
            server = "nixd";
            options = rec {
              nixos.expr = "(builtins.getFlake ''${flakePath}'').nixosConfigurations.${host}.options";
              home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions []";
            };
          };
          treesitter.enable = true;
        };

        clang.enable = true;
        zig.enable = true;
        python.enable = true;

        markdown = {
          enable = true;
          extensions.render-markdown-nvim.enable = true;
        };

        ts = {
          enable = true;
          lsp.enable = true;
          format.type = "prettierd";
          extensions.ts-error-translator.enable = true;
        };

        html.enable = true;
        lua.enable = true;
        css.enable = false;
        typst.enable = true;

        rust = {
          enable = true;
          crates.enable = true;
        };
      };

      visuals = {
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        indent-blankline.enable = true;
        rainbow-delimiters.enable = true;
      };

      statusline.lualine = {
        enable = true;
        theme = "base16";
      };

      autopairs.nvim-autopairs.enable = true;
      autocomplete.nvim-cmp.enable = true;
      snippets.luasnip.enable = true;
      tabline.nvimBufferline = {
        enable = true;
        setupOpts.options = {
          numbers = "none";
          show_close_icon = false;
        };
      };

      treesitter.context.enable = false;

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false;
      };

      dashboard.alpha = {
        enable = true;
        theme = "theta";
      };

      projects.project-nvim.enable = true;
      filetree.neo-tree.enable = true;
      notify = {
        nvim-notify.enable = true;
        nvim-notify.setupOpts.background_colour = config.lib.stylix.colors.withHashtag.base01;
      };

      utility = {
        preview.markdownPreview.enable = true;
        ccc.enable = false;
        vim-wakatime.enable = false;
        icon-picker.enable = true;
        surround.enable = true;
        diffview-nvim.enable = true;
        motion = {
          hop.enable = true;
          leap.enable = true;
          precognition.enable = false;
        };
        images = {
          image-nvim.enable = false;
        };
        yazi-nvim.enable = true;
      };

      ui = {
        borders.enable = true;
        noice.enable = true;
        colorizer.enable = true;
        illuminate.enable = true;
        breadcrumbs = {
          enable = false;
          navbuddy.enable = false;
        };
        smartcolumn = {
          enable = true;
        };
        fastaction.enable = true;
      };

      session = {
        nvim-session-manager.enable = false;
      };

      comments = {
        comment-nvim.enable = true;
      };

      terminal.toggleterm = {
        enable = true;
        lazygit = {
          enable = true;
        };
      };
    };
  };
}
