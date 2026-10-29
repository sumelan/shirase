{
  self,
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.lib) getExe;
in {
  programs = {
    mango = {
      enable = false;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.mango.override {
        pkg = inputs.mangowm.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
    };

    uwsm = {
      enable = true;
      waylandCompositors = {
        mango = {
          prettyName = "MangoWM";
          comment = "MangoWM managed by UWSM";
          binPath = getExe config.programs.mango.package;
        };
      };
    };
  };
}
