{ pkgs, ... }:
{
  imports = [
    ./keymaps.nix
  ];

  programs.neovim.enable = true;

  programs.nvf = {
    enable = true;
    settings = {
      vim.viAlias = true;
      vim.vimAlias = true;
      vim.lsp.enable = true;
      vim.theme = {
        enable = true;
        transparent = false;
      };

      vim.withNodeJs = true;
      vim.globals.mapleader = " ";

      vim.options = {
        cursorlineopt = "line";
        autoindent = true;
        #  Use 4 spaces for <Tab> and :retab
        tabstop = 2;
        shiftwidth = 2;
      };
      vim.useSystemClipboard = true;
      vim.preventJunkFiles = true;
      vim.filetree.nvimTree.setupOpts = {
        view = {
          number = true;
          relativenumber = true;
        };
      };
      vim.searchCase = "sensitive";
      vim.extraPackages = with pkgs; [
        lua-language-server
        gopls
        xclip
        wl-clipboard
        luajitPackages.lua-lsp
        nil
        nixd
        rust-analyzer
        #nodePackages.bash-language-server
        yaml-language-server
        pyright
        marksman
      ];
      vim.startPlugins = with pkgs.vimPlugins; [
        alpha-nvim
        auto-session
        bufferline-nvim
        dressing-nvim
        indent-blankline-nvim
        nui-nvim
        nvim-notify
        noice-nvim
        nvim-treesitter.withAllGrammars
        lualine-nvim
        nvim-autopairs
        nvim-web-devicons
        nvim-cmp
        nvim-surround
        nvim-lspconfig
        cmp-nvim-lsp
        cmp-buffer
        lazygit-nvim
        luasnip
        cmp_luasnip
        friendly-snippets
        lspkind-nvim
        comment-nvim
        nvim-ts-context-commentstring
        plenary-nvim
        neodev-nvim
        luasnip
        telescope-nvim
        todo-comments-nvim
        nvim-tree-lua
        telescope-fzf-native-nvim
        vim-tmux-navigator
        vim-just
      ];
      vim.extraPlugins = with pkgs.vimPlugins; {
        ibl = {
          package = indent-blankline-nvim;
          setup = "require('ibl').setup()";
        };

        bufferLine = {
          package = bufferline-nvim;
          setup = "require('bufferline').setup{}";
        };

        lualine = {
          package = lualine-nvim;
          setup = "require('lualine').setup({
            icons_enabled = true,
          })";
        };
      };
      vim.extraLuaFiles = [
        (builtins.path {
          path = ./plugins/alpha.lua;
          name = "alpha";
        })
        (builtins.path {
          path = ./plugins/autopairs.lua;
          name = "autopairs";
        })
        (builtins.path {
          path = ./plugins/auto-session.lua;
          name = "auto-session";
        })
        (builtins.path {
          path = ./plugins/comment.lua;
          name = "comment";
        })
        (builtins.path {
          path = ./plugins/cmp.lua;
          name = "cmp";
        })
        (builtins.path {
          path = ./plugins/lsp.lua;
          name = "lsp";
        })
        (builtins.path {
          path = ./plugins/noice.lua;
          name = "noice";
        })
        (builtins.path {
          path = ./plugins/nvim-tree.lua;
          name = "nvim-tree";
        })
        (builtins.path {
          path = ./plugins/telescope.lua;
          name = "telescope";
        })
        (builtins.path {
          path = ./plugins/todo-comments.lua;
          name = "todo-comments";
        })
        (builtins.path {
          path = ./plugins/treesitter.lua;
          name = "treesitter";
        })
      ];
    };
  };

  stylix.targets.nvf.enable = true;
}
