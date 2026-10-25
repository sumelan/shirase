_: {
  vim = {
    filetree.neo-tree.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<leader>nt";
        action = ":Neotree float<CR>";
      }
    ];
  };
}
