{config, ...}: {
  flake.custom.hjemConfigs.local = {
    pkgs,
    user,
    ...
  }: let
    local = config.flake.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    hjem.users.${user} = {
      packages = builtins.attrValues {
        inherit
          (local)
          starship
          bat
          batman
          eza
          eza-tree
          moor
          ripgrep
          ns
          kitty
          ;
      };

      xdg.mime-apps = {
        default-applications = {
          "x-scheme-handler/terminal" = "kitty.desktop";
        };
      };
    };

    environment.sessionVariables = {
      TERMINAL = "kitty";
    };
  };
}
