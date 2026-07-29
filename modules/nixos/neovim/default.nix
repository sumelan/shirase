{config, ...}: {
  flake.modules.nixos.default = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    environment = {
      systemPackages = builtins.attrValues {
        inherit (local) nvf;
      };

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
    };

    hjem.users.${user} = {
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
  };
}
