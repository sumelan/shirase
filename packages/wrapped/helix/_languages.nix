{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  language = [
    {
      name = "nix";
      auto-format = true;
      formatter = {command = getExe pkgs.alejandra;};
    }
    {
      name = "json";
      auto-format = true;
      formatter = {
        command = getExe pkgs.biome;
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
        command = getExe pkgs.ruff;
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
      command = getExe pkgs.ruff;
      args = ["server"];
    };
    json = {
      command = getExe pkgs.vscode-json-languageserver;
      args = ["--stdio"];
    };
    basedpyright = {
      command = getExe pkgs.basedpyright;
      args = ["--stdio"];
      config.basedpyright.analysis = {
        typeCheckingMode = "standard";
      };
    };
    nixd = {
      command = getExe pkgs.nixd;
      args = ["--semantic-tokens=true"];
    };
  };
}
