{
  self,
  pkgs,
  ...
}: {
  hjem.users.sumelan = {
    packages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.monstar
    ];

    xdg.mime-apps.default-applications = {
      "x-scheme-handler/terminal" = "dev.rockorager.monstar.desktop";
    };
  };

  environment.sessionVariables = {
    TERMINAL = "monstar";
  };

  # fix opening terminal for nautilus by using xdg-terminal-exec spec
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = ["dev.rockorager.monstar.desktop"];
    };
  };
}
