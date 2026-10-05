_: {
  flake.modules.nvf.default = {
    vim.keymaps = [
      {
        mode = "n";
        key = "<M-w>";
        action = ":bdelete<CR>";
        silent = true;
      }
      {
        mode = "n";
        key = "<M-,>";
        action = ":bprevious<CR>";
        silent = true;
      }
      {
        mode = "n";
        key = "<M-.>";
        action = ":bnext<CR>";
        silent = true;
      }
      {
        # Remove F1 for help
        mode = ["n" "i" "v"];
        key = "<F1>";
        action = "<Nop>";
        silent = true;
      }
    ];
  };
}
