{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    cliphist
    fd
    jq
    wl-clipboard
    wtype
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        placeholder = "Type to search...";
        prompt = "'❯ '";
        icon-theme = "Papirus";
        launch-prefix = "uwsm app --";
        match-counter = true;
        terminal = "${config.hm.custom.terminal}";
        horizontal-pad = 40;
        vertical-pad = 20;
        inner-pad = 15;
      };

      border = {
        width = 2;
        radius = 7;
      };
    };
  };

  home.file = {
    "bin/fuzzel-actions" = {
      source = ./scripts/fuzzel-actions.fish;
      executable = true;
    };
    "bin/fuzzel-clipboard" = {
      source = ./scripts/fuzzel-clipboard.fish;
      executable = true;
    };
    "bin/fuzzel-files" = {
      source = ./scripts/fuzzel-files.fish;
      executable = true;
    };
    "bin/fuzzel-vpnc" = {
      source = ./scripts/fuzzel-vpnc.fish;
      executable = true;
    };
  };

}
