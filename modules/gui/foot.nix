{
  inputs,
  lib,
  self,
  ...
}: let
  inherit (builtins) typeOf;
  inherit (lib) mkOption filterAttrs mkDefault getExe mkForce;
  inherit (lib.generators) mkKeyValueDefault mkValueStringDefault;
  inherit (lib.types) attrsOf oneOf;
in {
  flake.wrapperModules.foot = inputs.wrappers.lib.wrapModule (
    {
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
      baseFootConf = {
        font = "Maple Mono NF:size=14";
        initial-window-size-pixels = "1000x800";
        scrollback = {
          lines = 100000;
        };
        cursor = {
          style = "beam";
          blink = "yes";
          blink-rate = 500;
          beam-thickness = 2.0;
        };
        mouse = {
          hide-when-typing = "yes";
        };
      };
    in {
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

      config.package = mkDefault config.pkgs.foot;
      config.filesToPatch = ["share/systemd/user/foot-server.service"];
      config.flags = {
        "--config" = toString config."foot.ini".path;
      };
    }
  );

  perSystem = {pkgs, ...}: {
    packages.foot = (self.wrapperModules.foot.apply {inherit pkgs;}).wrapper;
  };

  flake.modules = {
    nixos.default = {
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
            foot =
              (self.wrapperModules.foot.apply {
                pkgs = prev;
                extraSettings =
                  {
                    include = "${prev.foot.themes}/share/foot/themes/nord";
                    main.shell = mkForce fishPath;
                    environment."SHELL" = fishPath;
                  }
                  // config.custom.programs.foot.extraSettings;
              }).wrapper;
          })
        ];
      };
    };

    homeManager.foot = {pkgs, ...}: {
      home.packages = [
        pkgs.foot # overlay-ed above
      ];

      custom.programs.print-config = {
        foot =
          # sh
          ''moor --lang ini "${pkgs.foot.flags."--config"}"'';
      };
    };
  };
}
