{config, ...}: {
  flake.modules.nvf.default = {
    imports = with config.flake.modules.nvf; [
      fzflua
      ui
      vim
      dashboard-alpha
    ];
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

      git = {
        enable = true;
        git-conflict.enable = true;
        gitsigns.enable = true;
      };

      terminal.toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };
  };
}
