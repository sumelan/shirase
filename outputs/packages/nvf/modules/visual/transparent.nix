_: {
  flake.modules.nvf.transparent = {pkgs, ...}: let
    inherit (pkgs) vimPlugins;
  in {
    vim = {
      startPlugins = [
        vimPlugins.transparent-nvim
      ];
      keymaps = [
        {
          mode = "n";
          key = "<leader>tt";
          action = ":TransparentToggle<CR>";
        }
      ];
    };
  };
}
