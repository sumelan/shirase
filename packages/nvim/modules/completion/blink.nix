{pkgs, ...}: {
  vim = {
    autocomplete = {
      enableSharedCmpSources = true;
      blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
      };
    };
    # I do not wish to constantly recompile it
    lazy.plugins.blink-cmp = {
      package = pkgs.lib.mkForce pkgs.vimPlugins.blink-cmp;
      # Needs the custom loader as the pname and attr keys do not match
      load = ''
        vim.opt.runtimepath:append("${pkgs.vimPlugins.blink-cmp}")
      '';
    };
  };
}
