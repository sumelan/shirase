_: {
  home.shellAliases = {
    z = "zoxide query -i";
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    options = ["--cmd cd"];
  };

  custom.persist = {
    home.cache.directories = [".local/share/fish"];
  };
}
