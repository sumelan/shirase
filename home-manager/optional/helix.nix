{
  lib,
  config,
  pkgs,
  host,
  flakePath,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    getExe
    getExe'
    ;
in {
  options.custom = {
    helix.enable =
      mkEnableOption "A post-modern modal text editor";
  };

  config = mkIf config.custom.helix.enable {
    programs.helix = {
      enable = true;
      settings = {
        editor = {
          line-number = "relative";
          cursorline = true;
          auto-format = true;
          completion-replace = true;
          rulers = [80];
          bufferline = "multiple";
          color-modes = true;
          trim-trailing-whitespace = true;
          trim-final-newlines = true;
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

          clipboard-provider = "wayland";
        };
      };

      languages = {
        language = let
          prettier = lang: {
            command = getExe pkgs.prettier;
            args = [
              "--parser"
              lang
            ];
          };
        in [
          {
            name = "bash";
            auto-format = true;
            formatter = {
              command = getExe pkgs.shfmt;
              args = [
                "-i"
                "2"
              ];
            };
          }
          {
            name = "css";
            auto-format = true;
            formatter = prettier "css";
            language-servers = [
              "vscode-css-language-server"
              "codebook"
            ];
          }
          {
            name = "git-commit";
            language-servers = ["ltex-ls-plus"];
          }
          {
            name = "go";
            auto-format = true;
            language-servers = [
              "gopls"
              "golangci-lint-langserver"
              "codebook"
            ];
          }
          {
            name = "html";
            auto-format = true;
            formatter = prettier "html";
            language-servers = [
              "vscode-html-language-server"
              "superhtml"
              "codebook"
            ];
          }
          {
            name = "javascript";
            auto-format = true;
            formatter = prettier "typescript";
          }
          {
            name = "json";
            auto-format = true;
            formatter = prettier "json";
          }
          {
            name = "jsonc";
            auto-format = true;
            formatter = prettier "jsonc";
          }
          {
            name = "markdown";
            auto-format = true;
            soft-wrap.enable = true;
            formatter = prettier "markdown";
            language-servers = [
              "marksman"
              "ltex-ls-plus"
            ];
          }
          {
            name = "nix";
            auto-format = true;
            language-servers = ["nixd"];
          }
          {
            name = "php";
            auto-format = true;
            formatter.command = getExe pkgs.pretty-php;
            language-servers = ["phpactor"];
          }
          {
            name = "python";
            auto-format = true;
            formatter = {
              command = getExe pkgs.ruff;
              args = [
                "format"
                "--line-length=80"
                "-"
              ];
            };
            language-servers = [
              "ty"
              "basedpyright"
              "ruff"
              "gpt"
              "codebook"
            ];
          }
          {
            name = "sql";
            language-servers = ["sqls"];
          }
          {
            name = "typescript";
            auto-format = true;
            formatter = prettier "typescript";
          }
          {
            name = "tsx";
            auto-format = true;
            formatter = prettier "typescript";
          }
          {
            name = "typst";
            auto-format = true;
            language-servers = [
              "tinymist"
              "ltex-ls-plus"
            ];
          }
          {
            name = "xml";
            language-servers = ["lemminx"];
          }
          {
            name = "yaml";
            auto-format = true;
            formatter = prettier "yaml";
          }
        ];

        language-server = {
          basedpyright = {
            command = getExe' pkgs.basedpyright "basedpyright-langserver";
            config.python.analysis.typeCheckingMode = "basic";
          };
          bash-language-server.command = lib.getExe pkgs.bash-language-server;
          codebook = {
            command = getExe pkgs.codebook;
            args = ["serve"];
          };
          docker-compose-langserver.command = getExe pkgs.docker-compose-language-service;
          fish-lsp.command = getExe pkgs.fish-lsp;
          golangci-lint-lsp.command = getExe pkgs.golangci-lint-langserver;
          gopls.command = getExe pkgs.gopls;
          lemminx.command = getExe pkgs.lemminx;
          ltex-ls-plus.command = getExe' pkgs.ltex-ls-plus "ltex-ls-plus";
          marksman.command = getExe pkgs.marksman;
          nixd = {
            command = getExe pkgs.nixd;
            config.nixd = {
              formatting.command = ["${getExe pkgs.alejandra}"];
              options = rec {
                nixos.expr = "(builtins.getFlake ''${flakePath}'').nixosConfigurations.${host}.options";
                home-manager.expr = "${nixos.expr}.home-manager.users.type.getSubOptions []";
              };
            };
          };
          phpactor = {
            command = getExe pkgs.phpactor;
            args = ["language-server"];
          };
          ruff.command = getExe pkgs.ruff;
          sqls.command = getExe pkgs.sqls;
          superhtml.command = getExe pkgs.superhtml;
          taplo.command = getExe pkgs.taplo;
          terraform-ls.command = getExe pkgs.terraform-ls;
          tinymist = {
            command = getExe pkgs.tinymist;
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
          ty.command = getExe pkgs.ty;
          typescript-language-server.command = getExe pkgs.typescript-language-server;
          vscode-css-language-server.command = getExe' pkgs.vscode-langservers-extracted "vscode-css-language-server";
          vscode-html-language-server.command = getExe' pkgs.vscode-langservers-extracted "vscode-html-language-server";
          vscode-json-language-server.command = getExe' pkgs.vscode-langservers-extracted "vscode-json-language-server";
          yaml-language-server.command = getExe pkgs.yaml-language-server;
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
