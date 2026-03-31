_: let
  inherit (builtins) attrValues;
in {
  flake.modules.nixos.hjem-gui = {pkgs, ...}: {
    hj.packages = attrValues {
      inherit
        (pkgs)
        dissent
        slack
        vesktop
        ;
    };

    custom.fileSystem = {
      persist.home.directories = [
        ".config/dissent"
        ".config/Slack"
        ".config/vesktop"
      ];
      cache.home.directories = [
        ".cache/dissent"
      ];
    };
  };
}
