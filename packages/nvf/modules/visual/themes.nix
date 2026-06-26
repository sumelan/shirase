_: {
  flake.modules.nvf.themes = _: {
    vim = {
      # https://github.com/NotAShelf/nvf/blob/main/modules/plugins/theme/supported-themes.nix
      theme = {
        enable = true;
        name = "nord";
      };
    };
  };
}
