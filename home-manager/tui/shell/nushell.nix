{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = with lib; {
    nushell.enable = mkEnableOption "nushell";
  };

  config = lib.mkIf config.custom.nushell.enable {
    home.packages = with pkgs; [
      broot
      carapace
    ];

    programs = {
      nushell = {
        enable = true;
        configFile.source = ./nushell-config.nu;
        envFile.source = ./nushell-env.nu;

        # FIX: https://github.com/nix-community/home-manager/issues/4313
        environmentVariables = builtins.mapAttrs (
          name: value: "${builtins.toString value}"
        ) config.home.sessionVariables;
      };
    };
  };
}
