_: {
  vim.languages = {
    bash.enable = true;

    markdown = {
      enable = true;
      extensions.render-markdown-nvim.enable = true;
    };

    clang.enable = true;

    zig.enable = true;

    python.enable = true;

    ts = {
      enable = true;
      lsp.enable = true;
      format.type = ["prettierd"];
      extensions.ts-error-translator.enable = true;
    };

    html.enable = true;

    lua.enable = true;

    css.enable = false;

    typst.enable = true;

    rust = {
      enable = true;
      extensions.crates-nvim.enable = true;
    };
  };
}
