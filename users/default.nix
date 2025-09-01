{
  lib,
  config,
  pkgs,
  user,
  ...
}: let
  inherit
    (lib)
    mkOption
    getExe
    types
    ;

  profile = with types;
    submodule {
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
            default = getExe config.profile.${user}.defaultEditor.package;
          };
        };
        defaultTerminal = {
          package = mkOption {
            type = package;
            description = "Terminal package to use as default";
            default = pkgs.kitty;
          };
          name = mkOption {
            type = str;
            description = "Terminal name to use as default";
            default = config.profile.${user}.defaultTerminal.package.pname;
          };
        };
      };
    };
in {
  services.accounts-daemon.enable = true;

  hm.options = with types; {
    profiles = mkOption {
      type = attrsOf profile;
    };
  };
}
