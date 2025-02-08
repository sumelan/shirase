{ ... }:{
  home.shellAliases = {
    z = "zoxide query -i";
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    options = [ "--cmd cd" ];
  };
}
