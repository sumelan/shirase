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
          completion-replace = false;
          rulers = [80];
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
          clipboard-provider = "wayland";
        };
      };

      languages = {
        language = [
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
            formatter = {
              command = getExe pkgs.prettier;
              args = [
                "--parser"
                "css"
              ];
            };
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
            formatter = {
              command = getExe pkgs.prettier;
              args = [
                "--parser"
                "html"
              ];
            };
            language-servers = [
              "vscode-html-language-server"
              "superhtml"
              "codebook"
            ];
          }
          {
            name = "markdown";
            auto-format = true;
            soft-wrap.enable = true;
            formatter = {
              command = getExe pkgs.nodePackages.prettier;
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
            language-servers = ["nixd"];
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
            name = "typst";
            auto-format = true;
            language-servers = ["tinymist"];
          }
          {
            name = "xml";
            language-servers = ["lemminx"];
          }
        ];

        language-server = {
          basedpyright = {
            command = getExe pkgs.basedpyright;
            args = ["--stdio"];
          };
          codebook = {
            command = getExe pkgs.codebook;
            args = ["serve"];
          };
          lemminx = {
            command = getExe pkgs.lemminx;
          };
          ltex = {
            command = getExe pkgs.ltex-ls-plus;
          };
          nixd = {
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
          sqls = {
            command = getExe pkgs.sqls;
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
