{user, ...}: {
  programs = {
    git = {
      enable = true;
      userName = user;
      userEmail = "sumelan@proton.me";
      difftastic = {
        enable = true;
        background = "dark";
      };
      extraConfig = {
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
  };
}
