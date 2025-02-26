{ self, pkgs, ...}:
{
  home.packages = [
    self.packages.${pkgs.system}.fuzzel-scripts
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        placeholder = "Type to search...";
        prompt = "'❯ '";
        icon-theme = "Papirus";
        match-counter = true;
        terminal = "${pkgs.kitty}/bin/kitty";
        width = 22;
        lines = 10;
        horizontal-pad = 40;
        vertical-pad = 20;
        inner-pad = 15;
      };
      border = {
        width = 2;
        radius = 8;
      };
    };
  };
}
