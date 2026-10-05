_: {
  flake.modules.nvf.toggleterm = _: {
    vim.terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
        setupOpts = {
          direction = "float";
          winbar.enabled = true;
        };
      };
    };
  };
}
