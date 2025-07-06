{
  lib,
  config,
  pkgs,
  host,
  user,
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
            name = "css";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.nodePackages.prettier;
              args = [
                "--parser"
                "css"
              ];
            };
          }
          {
            name = "git-commit";
            language-servers = [ "ltex" ];
          }
          {
            name = "go";
            auto-format = true;
          }
          {
            name = "html";
            formatter = {
              command = lib.getExe pkgs.nodePackages.prettier;
              args = [
                "--parser"
                "html"
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
              "ltex"
            ];
          }
          {
            name = "nix";
            auto-format = true;
            language-servers = [ "nixd" ];
          }
          {
            name = "php";
            auto-format = true;
            formatter.command = lib.getExe pkgs.pretty-php;
            language-servers = [ "phpactor" ];
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
            name = "sql";
            language-servers = [ "sqls" ];
          }
          {
            name = "typst";
            auto-format = true;
            language-servers = [ "tinymist" ];
          }
          {
            name = "xml";
            language-servers = [ "lemminx" ];
          }
        ];

        language-server = {
          basedpyright = {
            command = lib.getExe pkgs.basedpyright;
            args = [ "--stdio" ];
          };

          lemminx = {
            command = lib.getExe pkgs.lemminx;
          };

          ltex = {
            command = lib.getExe pkgs.ltex-ls;
          };

          nixd = {
            config.nixd = {
              formatting.command = [ "${lib.getExe pkgs.nixfmt}" ];
              options =
                let
                  flake = ''(builtins.getFlake "${config.profiles.${user}.flakePath}")'';
                in
                rec {
                  nixos.expr = "${flake}.nixosConfigurations.${host}.options";
                  home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions []";
                };
            };
          };

          phpactor = {
            command = lib.getExe pkgs.phpactor;
            args = [ "language-server" ];
          };

          sqls = {
            command = lib.getExe pkgs.sqls;
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
