{
  self,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) mkDefault;
in {
  hjem.users.sumelan.rum = {
    programs.foot = let
      extraConfig = {
        main = {
          shell = "nu";
          include = pkgs.foot.themes + "/share/foot/themes/catppuccin-frappe";
        };
      };
    in {
      enable = mkDefault false;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.foot.override {inherit extraConfig;};
      server.enable = true;
    };
  };
}
