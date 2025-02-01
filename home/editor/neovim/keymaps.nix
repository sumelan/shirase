{ ... }:
{
  programs.nvf = {
    settings.vim.keymaps = [
      {
        key = "jk";
        mode = [ "i" ];
        action = "<ESC>";
        silent = true;
        desc = "Exit insert mode with jk";
      }
      {
        key = "<leader>nh";
        mode = [ "n" ];
        action = ":nohl<CR>";
        silent = true;
        desc = "Clear search highlights";
      }
      {
        key = "<leader>sv";
        mode = [ "n" ];
        action = "<C-w>v";
        silent = true;
        desc = "Split window vertically";
      }
      {
        key = "<leader>sh";
        mode = [ "n" ];
        action = "<C-w>s";
        silent = true;
        desc = "Split window horizontally";
      }
      {
        key = "<leader>se";
        mode = [ "n" ];
        action = "<C-w>=";
        silent = true;
        desc = "Make splits equal size";
      }
      {
        key = "<leader>sx";
        mode = [ "n" ];
        action = "<cmd>close<CR>";
        silent = true;
        desc = "Close current split";
      }
      {
        key = "<leader>to";
        mode = [ "n" ];
        action = "<cmd>tabnew<CR>";
        silent = true;
        desc = "Open new tab";
      }
      {
        key = "<leader>tx";
        mode = [ "n" ];
        action = "<cmd>tabclose<CR>";
        silent = true;
        desc = "Close current tab";
      }
      {
        key = "<leader>tn";
        mode = [ "n" ];
        action = "<cmd>tabn<CR>";
        silent = true;
        desc = "Go to next tab";
      }
      {
        key = "<leader>tp";
        mode = [ "n" ];
        action = "<cmd>tabp<CR>";
        silent = true;
        desc = "Go to previous tab";
      }
      {
        key = "<leader>tf";
        mode = [ "n" ];
        action = "<cmd>tabnew %<CR>";
        silent = true;
        desc = "Open current buffer in new tab";
      }
    ];
  };
}
