_: {
  flake.modules.nvf.languages = _: {
    vim = {
      lsp = {
        enable = true;
        formatOnSave = true;
        lightbulb.enable = true;
        trouble.enable = true;
        otter-nvim.enable = true;
        presets.harper.enable = false;
      };
      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        bash.enable = true;
        yaml.enable = true;
      };
      treesitter = {
        enable = true;
        context.enable = true;
        fold = true;
      };
      keymaps = [
        {
          mode = "n";
          key = "<leader>lf";
          action = ":lua vim.lsp.buf.format()<CR>";
          silent = true;
        }
      ];
    };
  };
}
