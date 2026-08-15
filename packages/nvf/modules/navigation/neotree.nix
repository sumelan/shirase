_: {
  flake.modules.nvf.neotree = _: {
    vim = {
      filetree.neo-tree.enable = true;

      keymaps = [
        {
          mode = "n";
          key = "<leader>nt";
          action = ":Neotree toggle<CR>";
        }
        {
          mode = "n";
          key = "<leader>nf";
          action = ":Neotree float<CR>";
        }
      ];
    };
  };
}
