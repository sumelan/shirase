{config, ...}: {
  flake.modules.nvf.default = {
    imports = builtins.attrValues {
      inherit
        (config.flake.modules.nvf)
        dashboard-alpha
        fzflua
        neotree
        telescope
        toggleterm
        ui
        ;
    };
    # https://notashelf.github.io/nvf/options.html
    vim = {
      autopairs.nvim-autopairs.enable = true;

      notes.todo-comments.enable = true;

      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };

      utility = {
        outline.aerial-nvim.enable = true;
        mkdir.enable = true;
        nix-develop.enable = true;
        oil-nvim.enable = true;
        motion.leap.enable = true;
      };

      spellcheck = {
        enable = false;
        ignoredFiletypes = ["toggleterm" "gitcommit"];
      };

      git = {
        enable = true;
        git-conflict.enable = true;
        gitsigns.enable = true;
      };
    };
  };
}
