{
  self,
  pkgs,
  hostName,
  flake,
}: {
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
      config = pkgs.lib.mkIf (flake != null) {
        nixd = let
          inputs =
            # nix
            ''(removeAttrs (import "${self}/.tack") ["" "__functor"])'';

          myFlake =
            # nix
            ''(builtins.getFlake "${flake}")'';
        in {
          nixpkgs.expr =
            # nix
            ''import ${inputs}.nixpkgs { }'';
          options = {
            nixos.expr =
              # nix
              ''${myFlake}.nixosConfigurations.${hostName}.options'';
          };
        };
      };
    };
  };
}
