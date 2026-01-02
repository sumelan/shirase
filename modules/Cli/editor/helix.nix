{lib, ...}: let
  inherit (lib) getExe getExe';
in {
  flake.modules.homeManager.default = {
    pkgs,
    host,
    user,
    ...
  }: {
    programs.helix = {
      enable = true;
      themes = {
        nordic = {
          # Nordic theme for Helix
          # From https://github.com/5-pebbles/nordic-helix
          # Author : Owen Friedman <5-pebble@protonmail.com>
          # License: MIT License

          # Syntax Highlighting
          "attribute" = {fg = "yellow_base";};
          "type" = {fg = "yellow_bright";};
          "type.enum.variant" = {fg = "cyan_bright";};
          "constructor" = {fg = "cyan_bright";};
          "constant" = {fg = "magenta_bright";};
          "constant.character" = {fg = "green_base";};
          "constant.character.escape" = {fg = "magenta_bright";};
          "string" = {fg = "green_base";};
          "string.regex" = {fg = "magenta_bright";};
          "comment" = {
            fg = "gray4";
            modifiers = ["italic"];
          };
          "variable" = {fg = "white0";};
          "variable.builtin" = {fg = "blue0";};
          "variable.other.member" = {fg = "cyan_bright";};
          "label" = {
            fg = "orange_base";
            modifiers = ["bold"];
          };
          "punctuation.delimiter" = {
            fg = "gray5";
            modifiers = ["italic"];
          };
          "punctuation.special" = {fg = "orange_base";};
          "keyword" = {fg = "orange_base";};
          "operator" = {fg = "white0";};
          "function" = {fg = "blue2";};
          "function.macro" = {fg = "red_base";};
          "tag" = {fg = "blue1";};
          "namespace" = {fg = "yellow_dim";};
          "special" = {fg = "orange_base";}; # fuzzy highlight (picker)

          # Markup Formatting
          "markup.heading.1" = {
            fg = "yellow_base";
            modifiers = ["bold"];
          };
          "markup.heading.2" = {
            fg = "orange_base";
            modifiers = ["bold"];
          };
          "markup.heading.3" = {
            fg = "magenta_base";
            modifiers = ["bold"];
          };
          "markup.heading.4" = {fg = "green_base";};
          "markup.heading.5" = {
            fg = "blue2";
            modifiers = ["italic"];
          };
          "markup.heading.6" = {
            fg = "cyan_base";
            modifiers = ["italic"];
          };
          "markup.bold" = {modifiers = ["bold"];};
          "markup.italic" = {modifiers = ["italic"];};
          "markup.list" = {fg = "orange_base";};
          "markup.link" = {
            fg = "blue1";
            "underline.style" = "line";
          };
          "markup.quote" = {
            fg = "gray4";
            modifiers = ["italic"];
          };

          # Diffs
          "diff.plus" = {fg = "green_base";};
          "diff.minus" = {fg = "red_base";};
          "diff.delta" = {fg = "blue1";};

          # UI
          "ui.background" = {
            fg = "white0";
            bg = "black2";
          };
          "ui.cursor" = {
            fg = "black1";
            bg = "gray4";
          };
          "ui.cursor.primary" = {
            fg = "black1";
            bg = "white0";
          };
          "ui.cursor.match" = {modifiers = ["bold"];};
          "ui.linenr" = {fg = "gray2";};
          "ui.linenr.selected" = {fg = "gray4";};
          "ui.statusline" = {
            fg = "white0";
            bg = "black0";
          };
          "ui.statusline.inactive" = {
            fg = "gray4";
            bg = "black0";
          };
          "ui.popup" = {bg = "black1";};
          "ui.window" = {fg = "gray4";};
          "ui.help" = {bg = "black1";};
          "ui.text.focus" = {bg = "gray2";};
          "ui.virtual.ruler" = {bg = "gray1";};
          "ui.menu" = {bg = "black1";};
          "ui.menu.selected" = {bg = "gray4";};
          "ui.menu.scroll" = {
            fg = "gray4";
            bg = "gray0";
          }; # fg sets thumb color, bg sets track color of scrollbar
          "ui.selection" = {bg = "gray2";};
          "ui.cursorline.primary" = {bg = "gray1";};

          # Diagnostic Messages
          "error" = {fg = "red_base";};
          "warning" = {fg = "yellow_base";};
          "info" = {fg = "blue1";};
          "hint" = {fg = "green_base";};
          "diagnostic.error" = {
            underline = {
              color = "red_base";
              style = "curl";
            };
          };
          "diagnostic.warning" = {
            underline = {
              color = "yellow_base";
              style = "curl";
            };
          };
          "diagnostic.info" = {
            underline = {
              color = "blue1";
              style = "curl";
            };
          };
          "diagnostic.hint" = {
            underline = {
              color = "green_base";
              style = "curl";
            };
          };

          # Color Palette
          palette = {
            # Black
            black0 = "#191D24";
            black1 = "#1E222A";
            black2 = "#222630";

            # Gray
            gray0 = "#242933";
            # Polar night
            gray1 = "#2E3440";
            gray2 = "#3B4252";
            gray3 = "#434C5E";
            gray4 = "#4C566A";
            # a light blue/gray
            # from @nightfox.nvim
            gray5 = "#60728A";

            # White
            # reduce_blue variant
            white0 = "#C0C8D8";
            # Snow storm
            white1 = "#D8DEE9";
            white2 = "#E5E9F0";
            white3 = "#ECEFF4";

            # Blue
            # Frost
            blue0 = "#5E81AC";
            blue1 = "#81A1C1";
            blue2 = "#88C0D0";

            # Cyan:
            cyan_base = "#8FBCBB";
            cyan_bright = "#9FC6C5";
            cyan_dim = "#80B3B2";

            # Aurora (from Nord theme)
            # Red
            red_base = "#BF616A";
            red_bright = "#C5727A";
            red_dim = "#B74E58";

            # Orange
            orange_base = "#D08770";
            orange_bright = "#D79784";
            orange_dim = "#CB775D";

            # Yellow
            yellow_base = "#EBCB8B";
            yellow_bright = "#EFD49F";
            yellow_dim = "#E7C173";

            # Green
            green_base = "#A3BE8C";
            green_bright = "#B1C89D";
            green_dim = "#97B67C";

            # Magenta
            magenta_base = "#B48EAD";
            magenta_bright = "#BE9DB8";
            magenta_dim = "#A97EA1";
          };
        };
      };
      settings = {
        theme = "nordic";
        editor = {
          line-number = "relative";
          cursorline = true;
          auto-format = true;
          completion-replace = true;
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
            command = "${pkgs.prettier}/bin/prettier";
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
              command = "${pkgs.shfmt}/bin/shfmt";
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
            formatter.command = "${pkgs.pretty-php}/bin/pretty-php";
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
            config.nixd = let
              flakePath = "/persist/home/${user}/Projects/shirase";
            in {
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

    custom.cache.home.directories = [
      # helix log
      ".cache/helix"
    ];
  };
}
