_: {
  flake.modules.nvf.toggleterm = _: {
    vim.terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };
  };
}
