{ pkgs, ... }:
{
  programs.neovim.enable = true;

  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;

        theme = {
          enable = true;
          transparent = false;
        };

        options = {
          cursorlineopt = "line";
          autoindent = true;
          #  Use 4 spaces for <Tab> and :retab
          tabstop = 2;
          shiftwidth = 2;
        };
        useSystemClipboard = true;
        preventJunkFiles = true;
        filetree.nvimTree.setupOpts = {
          view = {
            number = true;
            relativenumber = true;
          };
        };
        searchCase = "smart";

        luaConfigPost = # lua
          ''
            -- use default colorscheme in tty
            -- https://github.com/catppuccin/nvim/issues/588#issuecomment-2272877967
            vim.g.has_ui = #vim.api.nvim_list_uis() > 0
            vim.g.has_gui = vim.g.has_ui and (vim.env.DISPLAY ~= nil or vim.env.WAYLAND_DISPLAY ~= nil)

            if not vim.g.has_gui then
              if vim.g.has_ui then
                vim.o.termguicolors = false
                vim.cmd.colorscheme('default')
              end
              return
            end

            -- remove trailing whitespace on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              pattern = "*",
              command = "silent! %s/\\s\\+$//e",
            })

            -- save on focus lost
            vim.api.nvim_create_autocmd("FocusLost", {
              pattern = "*",
              command = "silent! wa",
            })

            -- absolute line numbers in insert mode, relative otherwise
            vim.api.nvim_create_autocmd("InsertEnter", {
              pattern = "*",
              command = "set number norelativenumber",
            })
            vim.api.nvim_create_autocmd("InsertLeave", {
              pattern = "*",
              command = "set number relativenumber",
            })
          '';

        dashboard.startify = {
          enable = true;
          changeToVCRoot = true;
        };

        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;

          bash.enable = true;
          html.enable = true;
          lua.enable = true;
          markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
          };
          nix = {
            enable = true;
            format.type = "nixfmt";
            lsp = {
              enable = true;
              server = "nixd";
            };
          };
          python.enable = true;
          rust = {
            enable = true;
            crates.enable = true;
          };
          tailwind.enable = true;
          ts = {
            enable = true;
            extensions.ts-error-translator.enable = true;
          };
        };

        lsp = {
          formatOnSave = true;
          lspkind.enable = true;
          otter-nvim.enable = true;
          trouble.enable = true;
        };

        autocomplete.nvim-cmp.enable = true;
        autopairs.nvim-autopairs.enable = true;
        binds.whichKey.enable = true;
        comments.comment-nvim.enable = true;
        filetree.nvimTree = {
          enable = true;
          openOnSetup = false;
        };
        git.enable = true;
        lazy.enable = true;
        notes.todo-comments.enable = true;
        projects.project-nvim.enable = true;
        snippets.luasnip.enable = true;
        statusline.lualine.enable = true;
        tabline.nvimBufferline = {
          enable = true;
          setupOpts.options = {
            numbers = "none";
            show_close_icon = false;
          };
        };
        telescope = {
          enable = true;
          mappings = {
            buffers = "<leader>fb";
            findFiles = "<leader>ff";
            gitBranches = "<leader>fb";
            gitStatus = "<leader>gs";
            liveGrep = "<leader>/";
          };
        };
        treesitter.autotagHtml = true;
        ui = {
          colorizer.enable = true;
          noice.enable = true;
          smartcolumn.enable = true;
        };
        utility = {
          motion.leap.enable = true;
          preview.markdownPreview.enable = true;
          surround.enable = true;
          yazi-nvim.enable = true;
        };
        visuals.nvim-web-devicons.enable = true;

        extraPlugins = with pkgs.vimPlugins; {
          direnv = {
            package = direnv-vim;
          };
          oil = {
            package = oil-nvim;
            setup = "require('oil').setup()";
          };
          rooter = {
            package = vim-rooter;
          };
          spectre = {
            package = nvim-spectre;
          };
          vim-tmux-navigator = {
            package = vim-tmux-navigator;
          };
        };
      };
    };
  };

  stylix.targets.nvf.enable = true;
}
