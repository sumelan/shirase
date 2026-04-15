_: let
  inherit (builtins) attrValues;
in {
  flake.modules.nixos.gui = {pkgs, ...}: {
    hj.packages = attrValues {
      inherit
        (pkgs)
        slack
        vesktop
        ;
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/Slack"
        ".config/vesktop"
      ];
    };
  };
}
