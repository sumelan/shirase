{
  lib,
  config,
  pkgs,
  user,
  ...
}:
let
  profile = lib.types.submodule {
    options = {
      timeZone = lib.mkOption {
        type = lib.types.str;
        description = "Time zone";
        default = "";
      };
      defaultLocale = lib.mkOption {
        type = lib.types.str;
        description = "Locale";
        default = "";
      };
      defaultEditor = {
        package = lib.mkOption {
          type = lib.types.package;
          description = "Editor package to use as default";
          default = pkgs.neovim;
        };
        name = lib.mkOption {
          type = lib.types.str;
          description = "Editor name to use as default";
          default = "nvim";
        };
      };
      defaultTerminal = {
        package = lib.mkOption {
          type = lib.types.package;
          description = "Terminal package to use as default";
          default = pkgs.kitty;
        };
        name = lib.mkOption {
          type = lib.types.str;
          description = "Terminal name to use as default";
          default = config.profile.${user}.defaultTerminal.package.pname;
        };
      };
    };
  };
in
{
  hm.options = {
    profiles = lib.mkOption {
      type = lib.types.attrsOf profile;
    };
  };
}
