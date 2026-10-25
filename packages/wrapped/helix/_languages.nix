_: {
  language = [
    {
      name = "nix";
      auto-format = true;
      formatter = {command = "alejandra";};
    }
    {
      name = "json";
      auto-format = true;
      formatter = {
        command = "biome";
        args = [
          "format"
          "--stdin-file-path"
          "%file"
        ];
      };
      language-servers = ["json"];
    }
    {
      name = "python";
      auto-format = false;
      formatter = {
        command = "ruff";
        args = [
          "format"
          "--quiet"
          "-"
        ];
      };
      language-servers = ["basedpyright" "ruff"];
    }
  ];

  language-server = {
    ruff = {
      command = "ruff";
      args = ["server"];
    };
    json = {
      command = "vscode-json-languageserver";
      args = ["--stdio"];
    };
    basedpyright = {
      command = "basedpyright";
      args = ["--stdio"];
      config.basedpyright.analysis = {
        typeCheckingMode = "standard";
      };
    };
    nixd = {
      command = "nixd";
      args = ["--semantic-tokens=true"];
    };
  };
}
