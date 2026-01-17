# NOTE: when you see a error,
# `fatal: The current branch master has multiple upstream branches, refusing to push.`
# run `git config remote.origin.push HEAD`
{
  config,
  lib,
  ...
}: let
  inherit (config.flake.lib.colors) orange_dim gray4;
  inherit (lib) mkForce;
in {
  flake.modules.homeManager.default = {user, ...}: {
    home.shellAliases = {
      gg = "lazygit";
    };

    programs = {
      git = {
        enable = true;
        settings = {
          user = {
            name = user;
            inherit (config.flake.meta.users.${user}) email;
          };
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
          diff = {
            tool = "nvim -d";
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
        };
      };
      difftastic = {
        enable = true;
        options.background = "dark";
        git.enable = true;
      };
      gh = {
        enable = true;
        settings = {
          editor = "code --wait";
          git_protocol = "https";
        };
      };
      lazygit = {
        enable = true;
        settings = mkForce {
          disableStartupPopups = true;
          notARepository = "skip";
          promptToReturnFromSubprocess = false;
          update.method = "never";
          git = {
            commit.signOff = true;
            parseEmoji = true;
          };
          gui = let
            accent = orange_dim;
            muted = gray4;
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
  };
}
