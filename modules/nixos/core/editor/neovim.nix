{
  self,
  config,
  pkgs,
  ...
}: let
  inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) nvim;
in {
  environment = {
    systemPackages = builtins.attrValues {
      inherit (pkgs) wl-clipboard-rs;

      nvim = nvim.override {
        flake = "/persist/home/sumelan/Projects/shirase";
        inherit (config.networking) hostName;
      };
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  hjem.users.sumelan = {
    xdg.mime-apps = {
      default-applications = {
        "text/plain" = "nvim.desktop";
        "application/x-shellscript" = "nvim.desktop";
        "application/xml" = "nvim.desktop";
      };
      added-associations = {
        "text/csv" = "nvim.desktop";
      };
    };
  };

  custom.fileSystem = {
    persist.home.directories = [
      ".supermaven"
      ".local/share/nvim" # data directory
      ".local/state/nvim" # persistent session info
      ".local/share/supermaven"
    ];
  };
}
