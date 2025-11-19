{
  lib,
  host ? "acer",
  flakePath ? "",
  ...
}: let
  inherit (lib) mkIf;
in {
  # https://notashelf.github.io/nvf/options.html
  vim = {
    viAlias = true;
    vimAlias = true;
    lineNumberMode = "relNumber";
    preventJunkFiles = true;
    searchCase = "smart";

    # https://github.com/NotAShelf/nvf/blob/main/modules/plugins/theme/supported-themes.nix
    theme = {
      enable = true;
      name = "nord";
    };

    clipboard = {
      enable = true;
      registers = "unnamedplus";
      providers = {
        wl-copy.enable = true;
        xsel.enable = true;
      };
    };

    autopairs.nvim-autopairs.enable = true;
    autocomplete.nvim-cmp.enable = true;

    filetree.neo-tree.enable = true;

    telescope = {
      enable = true;
    };

    dashboard.alpha = {
      enable = true;
      theme = "theta";
    };

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    comments = {
      comment-nvim.enable = true;
    };

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

    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      nix = {
        enable = true;
        extraDiagnostics = {
          enable = true;
          types = [
            "statix"
            "deadnix"
          ];
        };
        format = {
          enable = true;
          type = "alejandra";
        };
        lsp = {
          enable = true;
          server = "nixd";
        };
        treesitter.enable = true;
      };
    };

    lsp = {
      enable = true;
      formatOnSave = true;
      lspkind.enable = true;
      otter-nvim.enable = true;
      trouble.enable = true;

      servers.nixd = {
        init_options = mkIf (flakePath != "") rec {
          nixos.expr = "(builtins.getFlake ''${flakePath}'').nixosConfigurations.${host}.options";
          home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions []";
        };
      };
    };

    ui = {
      borders.enable = true;
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
    };

    visuals = {
      fidget-nvim.enable = true;
      indent-blankline.enable = true;
      nvim-web-devicons.enable = true;
      rainbow-delimiters.enable = true;
    };
  };
}
