_: {
  flake.modules.nvf.blink = _: {
    vim.autocomplete = {
      enableSharedCmpSources = true;
      blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
      };
    };
  };
}
