{
  lib,
  pkgs,
  user,
  ...
}:
let
  profile = lib.types.submodule {
    options = {
      flakeDir = lib.mkOption {
        type = lib.types.path;
        description = "filesystem path that contains dotfiles";
        default = "/home/" + user + "/shirase";
      };
      timeZone = lib.mkOption {
        type = lib.types.str;
        description = "Time zone";
        default = "Asia/Tokyo";
      };
      defaultLocale = lib.mkOption {
        type = lib.types.str;
        description = "Locale";
        default = "ja_JP.UTF-8";
      };
      defaultEditor.package = lib.mkOption {
        type = lib.types.package;
        description = "Editor to use as default";
        default = pkgs.neovim;
      };
      defaultTerminal.package = lib.mkOption {
        type = lib.types.package;
        description = "Terminal program to use as default";
        default = pkgs.kitty;
      };
    };
  };
in
{
  options = {
    profiles = lib.mkOption {
      type = lib.types.attrsOf profile;
    };
  };
}
