{
  lib,
  config,
  pkgs,
  user,
  ...
}:
let
  plugins-repo = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "86d28e4fb4f25f36cc501b8cb0badb37a6b14263";
    hash = "sha256-m/gJTDm0cVkIdcQ1ZJliPqBhNKoCW1FciLkuq7D1mxo=";
  };
in
{
  home.packages = with pkgs; [
    ripdrag # Drag and Drop utilty written in Rust and GTK4
    unar
    exiftool
  ];

  home.shellAliases = {
    lf = "yazi";
    y = "yazi";
  };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    settings = {
      manager = {
        show_hidden = true;
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
      # for git plugin
      plugin.prepend_fetches = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
    };

    plugins = {
      chmod = "${plugins-repo}/chmod.yazi";
      full-border = "${plugins-repo}/full-border.yazi";
      git = "${plugins-repo}/git.yazi";
      toggle-pane = "${plugins-repo}/toggle-pane.yazi";
      mount = "${plugins-repo}/mount.yazi";
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "6a0f3f788971b155cbc7cec47f6f11aebbc148c9";
        hash = "sha256-q1G0Y4JAuAv8+zckImzbRvozVn489qiYVGFQbdCxC98=";
      };
    };

    initLua = ''
      require("full-border"):setup()
      require("git"):setup()
      require("starship"):setup()
    '';

    keymap = {
      manager.prepend_keymap = [
        {
          on = "M";
          run = "plugin mount";
          desc = "Open mount";
        }
        {
          on = "T";
          run = "plugin toggle-pane max-preview";
          desc = "Maximize or restore the preview pane";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "<C-n>";
          run = "shell --confirm 'ripdrag \"$@\" -x 2>/dev/null &'";
        }
      ];
    };
  };

  programs.niri.settings = {
    binds = {
      "Mod+Shift+E" = lib.custom.niri.openTerminal {
        app = pkgs.yazi;
        terminal = config.profiles.${user}.defaultTerminal.package;
      };
    };
    window-rules = [
      {
        matches = [ { app-id = "^(yazi)"; } ];
        default-column-width.proportion = 0.5;
        default-window-height.proportion = 0.5;
        open-floating = true;
      }
    ];
  };
}
