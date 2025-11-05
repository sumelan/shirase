# NOTE: when you see a error,
# `fatal: The current branch master has multiple upstream branches, refusing to push.`
# run `git config remote.origin.push HEAD`
{
  config,
  user,
  ...
}: {
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = user;
          inherit (config.profiles.${user}) email;
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
  };
}
