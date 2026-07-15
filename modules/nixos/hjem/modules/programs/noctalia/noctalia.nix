{inputs, ...}: {
  flake.custom.hjemModules.noctalia = {pkgs, ...}: let
    waytator = inputs.waytator.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    imports = [inputs.noctalia.hjemModules.default];

    # plugin dependencies
    packages = builtins.attrValues {
      inherit (pkgs) mpvpaper gpu-screen-recorder;
      inherit waytator;
    };

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
    };

    xdg.state.files = {
      "noctalia/.setup-complete" = {
        permissions = "666";
        text = "";
        type = "copy";
      };
    };
  };
}
