{
  lib,
  self,
  ...
}: let
  inherit (builtins) typeOf;
  inherit (lib) mkOption filterAttrs mkDefault getExe mkForce;
  inherit (lib.generators) mkKeyValueDefault mkValueStringDefault;
  inherit (lib.types) attrsOf oneOf;
in {
  flake.wrappers.foot = {
    config,
    wlib,
    ...
  }: let
    inherit (wlib.types) file;
    iniFmt = config.pkgs.formats.iniWithGlobalSection {
      # from https://github.com/NixOS/nixpkgs/blob/89f10dc1a8b59ba63f150a08f8cf67b0f6a2583e/nixos/modules/programs/foot/default.nix#L11-L29
      listsAsDuplicateKeys = true;
      mkKeyValue = mkKeyValueDefault {
        mkValueString = v:
          mkValueStringDefault {} (
            if v == true
            then "yes"
            else if v == false
            then "no"
            else if v == null
            then "none"
            else v
          );
      } "=";
    };
    inherit (iniFmt.lib.types) atom;
    footOptions = {
      extraSettings = mkOption {
        type = attrsOf (oneOf [atom (attrsOf atom)]);
        default = {};
        description = ''
          Configuration of foot terminal.
          See {manpage}`foot.ini(5)`
        '';
      };
    };
    baseFootConf = import ./_config.nix {};
  in {
    imports = [wlib.modules.default];

    options =
      footOptions
      // {
        "foot.ini" = mkOption {
          type = file config.pkgs;
          default.path = iniFmt.generate "foot.ini" {
            globalSection = filterAttrs (_name: value: typeOf value != "set") (baseFootConf // config.extraSettings);
            sections = filterAttrs (_name: value: typeOf value == "set") (baseFootConf // config.extraSettings);
          };
          visible = false;
        };
      };

    config = {
      package = mkDefault config.pkgs.foot;
      filesToPatch = ["share/systemd/user/foot-server.service"];
      flags = {
        "--config" = toString config."foot.ini".path;
      };
    };
  };

  perSystem = {pkgs, ...}: {
    packages.foot = self.wrappers.foot.wrap {inherit pkgs;};
  };

  flake.modules.nixos.gui = {
    config,
    pkgs,
    ...
  }: let
    iniFmt = pkgs.formats.iniWithGlobalSection {
      # from https://github.com/NixOS/nixpkgs/blob/89f10dc1a8b59ba63f150a08f8cf67b0f6a2583e/nixos/modules/programs/foot/default.nix#L11-L29
      listsAsDuplicateKeys = true;
      mkKeyValue = mkKeyValueDefault {
        mkValueString = v:
          mkValueStringDefault {} (
            if v == true
            then "yes"
            else if v == false
            then "no"
            else if v == null
            then "none"
            else v
          );
      } "=";
    };
    inherit (iniFmt.lib.types) atom;
    footOptions = {
      extraSettings = mkOption {
        type = attrsOf (oneOf [atom (attrsOf atom)]);
        default = {};
        description = ''
          Configuration of foot terminal.
          See {manpage}`foot.ini(5)`
        '';
      };
    };

    fishPath = getExe config.programs.fish.package;
  in {
    options.custom = {
      programs.foot = footOptions;
    };

    config = {
      nixpkgs.overlays = [
        (_: prev: {
          foot = self.wrappers.foot.wrap {
            pkgs = prev;
            extraSettings =
              {
                font = "${config.custom.fonts.monospace}:size=14";
                include = "${prev.foot.themes}/share/foot/themes/nord";
                main.shell = mkForce fishPath;
                environment."SHELL" = fishPath;
              }
              // config.custom.programs.foot.extraSettings;
          };
        })
      ];

      programs.foot = {
        enable = true;
        xdg.serverAutostart = true;
      };

      hj.packages = [
        pkgs.foot # overlay-ed above
      ];

      custom.programs.print-config = {
        foot =
          # sh
          ''moor --lang ini "${pkgs.foot.configuration.flags."--config".data}"'';
      };
    };
  };
}
