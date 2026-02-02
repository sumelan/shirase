_: let
  inherit (builtins) attrValues;
in {
  flake.modules.homeManager.default = {pkgs, ...}: {
    home.packages = attrValues {
      inherit
        (pkgs)
        dissent
        slack
        vesktop
        ;
    };

    custom = {
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
