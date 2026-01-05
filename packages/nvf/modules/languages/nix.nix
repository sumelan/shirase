_: {
  flake.modules.nvf.nix = _: {
    vim.languages.nix = {
      enable = true;
      extraDiagnostics = {
        enable = true;
        types = ["deadnix" "statix"];
      };
      format = {
        enable = true;
        type = ["alejandra"];
      };
      lsp.servers = ["nil" "nixd"];
    };
  };
}
