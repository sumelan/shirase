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
      ];
    };
  };
}
