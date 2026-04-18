{
  inputs,
  config,
  lib,
  ...
}: let
  inherit (config) flake;
  inherit (lib) mkMerge concatStringsSep;
in {
  flake.modules.nixos.default = {
    pkgs,
    user,
    ...
  }: let
    gitignores = [
      ".direnv"
      ".devenv"
      ".envrc"
      ".jj"
      "node_modules"
    ];
  in
    mkMerge [
      {
        programs = {
          git = {
            enable = true;

            config = {
              init = {
                defaultBranch = "main";
              };
              alias = {
                # blame with ignore whitespace and track movement across all commits
                blame = "blame -w -C -C -C";
                diff = "diff --word-diff";
              };
              branch = {
                master = {
                  merge = "refs/heads/master";
                };
                main = {
                  merge = "refs/heads/main";
                };
                sort = "-committerdate";
              };
              core = {
                excludesFile = pkgs.writeText ".gitignore" (concatStringsSep "\n" gitignores);
              };
              diff = {
                guitool = "code";
                colorMoved = "default";
              };
              format = {
                pretty = "format:%C(yellow)%h%Creset -%C(red)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset";
              };
              merge = {
                conflictstyle = "diff3";
              };
              pull = {
                rebase = true;
              };
              push = {
                default = "simple";
              };
              # reuse record resolution: git automatically resolves conflicts using the recorded resolution
              rerere = {
                enabled = true;
                autoUpdate = true;
              };
              user = {
                name = user;
                inherit (flake.meta.users.${user}) email;
              };
            };
          };

          lazygit = {
            enable = true;
            settings = {
              disableStartupPopups = true;
              notARepository = "skip";
              promptToReturnFromSubprocess = false;
              update.method = "never";
              git = {
                commit.signOff = true;
                parseEmoji = true;
              };
              gui = let
                accent = "#F4B8E4";
                muted = "#414559";
              in {
                theme = {
                  activeBorderColor = [
                    accent
                    "bold"
                  ];
                  inactiveBorderColor = [muted];
                };
                showListFooter = false;
                showRandomTip = false;
                showCommandLog = false;
                showBottomLine = false;
                nerdFontsVersion = "3";
              };
            };
          };
        };

        environment.shellAliases = {
          gg = "lazygit";
        };

        custom.fileSystem = {
          persist.home.directories = [
            ".config/gitbutler"
          ];
        };
      }

      # difftastic
      {
        nixpkgs.overlays = [
          (_: prev: {
            difftastic = inputs.wrappers.lib.wrapPackage {
              pkgs = prev;
              package = prev.difftastic;
              flags = {
                "--background" = "dark";
              };
            };
          })
        ];

        environment.systemPackages = [
          pkgs.difftastic # overlay-ed above
        ];

        programs.git.config = {
          diff = {
            tool = "difftastic";
          };
          difftool = {
            difftastic = {
              cmd = "difft $LOCAL $REMOTE";
            };
          };
        };
      }
    ];
}
