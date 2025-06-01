_: {
  programs = {
    nushell = {
      enable = true;
      configFile.source = ./config/config.nu;
      shellAliases = {
        vi = "nvim";
        vim = "nvim";
        nano = "nvim";
      };
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    starship = {
      enableNushellIntegration = true;
      settings = {
        add_newline = true;
      };
    };
  };

  stylix.targets.nushell.enable = true;
}
