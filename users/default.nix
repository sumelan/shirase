{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption;

  inherit
    (lib.types)
    str
    package
    submodule
    attrsOf
    ;

  profile = submodule {
    options = {
      timeZone = mkOption {
        type = str;
        description = "Time zone";
        default = "";
      };
      defaultLocale = mkOption {
        type = str;
        description = "Locale";
        default = "";
      };
      email = mkOption {
        type = str;
        description = "Email address";
        default = "";
      };
      defaultEditor = {
        package = mkOption {
          type = package;
          description = "Editor package to use as default";
          default = pkgs.neovim;
        };
        name = mkOption {
          type = str;
          description = "Editor name to use as default";
          default = "nvim";
        };
      };
    };
  };
in {
  services.accounts-daemon.enable = true;

  hm.options = {
    profiles = mkOption {
      type = attrsOf profile;
    };
  };
}
