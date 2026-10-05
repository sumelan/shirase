{lib, ...}: let
  inherit (lib) getExe;
  mkFzfBind = keys: action: {
    mode = "n";
    key = "<leader>${keys}";
    action = ":FzfLua ${action}<CR>";
  };
in {
  flake.modules.nvf.fzflua = {pkgs, ...}: {
    vim = {
      fzf-lua = {
        enable = true;
        setupOpts.files = {
          cmd = "${getExe pkgs.fd} --type f --hidden --follow --exclude .git --exclude .direnv --exclude .arc";
        };
      };

      keymaps = [
        (mkFzfBind "ff" "files")
        (mkFzfBind "fg" "live_grep")
        (mkFzfBind "fr" "resume")
        (mkFzfBind "cs" "colorschemes")
        (mkFzfBind "gs" "git_status")
        (mkFzfBind "gd" "git_diff")
        (mkFzfBind "gb" "git_branches")
        (mkFzfBind "fu" "undo")
      ];
    };
  };
}
