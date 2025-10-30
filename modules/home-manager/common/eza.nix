_: {
  programs.eza = {
    enable = true;
    icons = "always";
    enableBashIntegration = true;
    enableFishIntegration = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--octal-permissions"
      "--hyperlink"
    ];
  };
}
