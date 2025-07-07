{
  lib,
  config,
  pkgs,
  host,
  flakePath,
  ...
}:
{
  options.custom = {
    helix.enable = lib.mkEnableOption "helix editor";
  };

  config = lib.mkIf config.custom.helix.enable {
    programs.helix = {
      enable = true;
      settings = {
        editor = {
          line-number = "relative";
          cursorline = true;
          auto-format = true;
          completion-replace = false;
          rulers = [ 80 ];
          bufferline = "multiple";
          color-modes = true;
          soft-wrap.enable = true;

          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "error";

          lsp.display-inlay-hints = true;

          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };

          indent-guides.render = true;
        };
      };
      languages = {
        language = [
          {
            name = "bash";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.shfmt;
              args = [
                "-i"
                "2"
              ];
            };
          }
          {
            name = "markdown";
            auto-format = true;
            soft-wrap.enable = true;
            formatter = {
              command = lib.getExe pkgs.nodePackages.prettier;
              args = [
                "--parser"
                "markdown"
              ];
            };
            language-servers = [
              "marksman"
              "ltex-ls-plus"
            ];
          }
          {
            name = "nix";
            auto-format = true;
            language-servers = [ "nixd" ];
          }
          {
            name = "python";
            language-servers = [
              "basedpyright"
              "ruff"
            ];
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.ruff;
              args = [
                "format"
                "--line-length=80"
                "-"
              ];
            };
          }
          {
            name = "typst";
            auto-format = true;
            language-servers = [ "tinymist" ];
          }
        ];

        language-server = {
          basedpyright = {
            command = lib.getExe pkgs.basedpyright;
            args = [ "--stdio" ];
          };

          ltex-ls-plus = {
            command = lib.getExe pkgs.ltex-ls-plus;
          };

          nixd = {
            config.nixd = {
              formatting.command = [ "${lib.getExe pkgs.nixfmt}" ];
              options =
                let
                  flake = ''(builtins.getFlake ("git+file://" + "${flakePath}"))'';
                in
                {
                  nixos.expr = ''${flake}.nixosConfigurations.${host}.options'';
                  home-manager.expr = "${flake}.homeConfigurations.${host}.options";
                };
            };
          };

          tinymist = {
            config = {
              exportPdf = "onType";
              outputPath = "$root/target/$dir/$name";
              formatterMode = "typstyle";
              formatterPrintWidth = 80;
              lint = {
                enabled = true;
                when = "onType";
              };
            };
          };
        };
      };
      ignores = [
        "!.github/"
        "!.gitignore"
        "!.gitattributes"
      ];
    };
  };
}
