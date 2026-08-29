_: {
  flake.modules.nvf.noice = _: {
    vim = {
      ui = {
        noice = {
          enable = true;
          setupOpts.lsp.signature.enabled = true;
        };
      };

      notify = {
        nvim-notify.enable = true;
      };
    };
  };
}
