{
  lib,
  host ? "acer",
  flakePath ? "",
  ...
}: {
  imports = [
    ./keymaps.nix
  ];

  # https://notashelf.github.io/nvf/options.html
  vim = {
    viAlias = true;
    vimAlias = true;

    theme = {
      enable = true;
      name = "catppuccin";
      style = "frappe";
    };

    options = {
      cursorline = true;
      gdefault = true;
      magic = true;
      matchtime = 2; # briefly jump to a matching bracket for 0.2s
      exrc = true; # use project specific vimrc
      smartindent = true;
      virtualedit = "block"; # allow cursor to move anywhere in visual block mode
      # Use 2 spaces for <Tab> and :retab
      tabstop = 4;
      softtabstop = 4;
      shiftwidth = 2;
      expandtab = true;
      shiftround = true; # round indent to multiple of 'shiftwidth' for > and < command
    };

    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers = {
        wl-copy.enable = true;
        xsel.enable = true;
      };
    };
    lineNumberMode = "relNumber";
    preventJunkFiles = true;
    searchCase = "smart";

    lsp = {
      enable = true;
      formatOnSave = true;
      lspkind.enable = true;
      otter-nvim.enable = true;
      trouble.enable = true;
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
          options = lib.mkIf (flakePath != "") rec {
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

    autopairs.nvim-autopairs.enable = true;
    autocomplete.nvim-cmp.enable = true;
    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };
    comments = {
      comment-nvim.enable = true;
    };
    dashboard.alpha = {
      enable = true;
      theme = "theta";
    };
    filetree.neo-tree.enable = true;
    git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions.enable = false;
    };
    notify = {
      nvim-notify.enable = true;
      nvim-notify.setupOpts.background_colour = "#181825";
    };
    notes.todo-comments.enable = true;
    projects.project-nvim.enable = true;
    session = {
      nvim-session-manager.enable = false;
    };
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
    };
    terminal.toggleterm = {
      enable = true;
      lazygit = {
        enable = true;
      };
    };
    treesitter = {
      enable = true;
      autotagHtml = true;
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
    visuals = {
      fidget-nvim.enable = true;
      indent-blankline.enable = true;
      nvim-web-devicons.enable = true;
      rainbow-delimiters.enable = true;
    };
  };
}
