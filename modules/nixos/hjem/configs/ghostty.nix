{self, ...}: {
  flake.modules.nixos.gui = {pkgs, ...}: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) ghostty;
  in {
    hj = {
      packages = [ghostty];

      xdg = {
        config.files."ghostty/config" = {
          permissions = "666";
          text = "";
          type = "copy";
        };

        mime-apps = {
          default-applications = {
            "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
          };
        };
      };
    };
  };
}
