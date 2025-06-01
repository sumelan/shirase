{ pkgs, ... }:
{
  home.packages = with pkgs; [
    slurp
    wf-recorder
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww;
    enableBashIntegration = true;
    enableFishIntegration = true;
    # eww option 'configDir' need to add executable on scripts
  };
  xdg.configFile = {
    "eww/statusbar" = {
      source = ./statusbar;
      recursive = true;
      executable = true;
    };
    "eww/sidebar" = {
      source = ./sidebar;
      recursive = true;
      executable = true;
    };
  };
}
