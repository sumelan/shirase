_: {
  flake.modules.nvf.themes = {pkgs, ...}: let
    inherit (pkgs) vimPlugins;
  in {
    vim = {
      # https://github.com/NotAShelf/nvf/blob/main/modules/plugins/theme/supported-themes.nix
      theme.enable = false;

      extraPlugins = {
        nordic = {
          package = vimPlugins.nordic-nvim;
          setup =
            # lua
            ''
              require('nordic').colorscheme({
                underline_option = 'none',
                italic = true,
                italic_comments = false,
                minimal_mode = false,
                alternate_backgrounds = false
              })
            '';
        };
      };
    };
  };
}
