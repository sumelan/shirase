{
  lib,
  self,
  ...
}: let
  inherit
    (lib)
    mkDefault
    mkOption
    mkEnableOption
    concatStringsSep
    isBool
    isString
    ;
  inherit (lib.generators) toKeyValue mkKeyValueDefault;
  inherit
    (lib.types)
    listOf
    attrsOf
    oneOf
    bool
    float
    int
    str
    ;

  btopOptions = {
    cudaSupport = mkEnableOption {
      description = "Enable nvidia support for btop";
    };

    rocmSupport = mkEnableOption {
      description = "Enable radeon support for btop";
    };

    extraSettings = mkOption {
      type = attrsOf (oneOf [bool float int str]);
      default = {};
      example = {
        color_theme = "Default";
        theme_background = false;
      };
      description = ''
        Options to add to {file}`btop.conf` file.
        See `https://github.com/aristocratos/btop#configurability` for options.
      '';
    };
  };
in {
  flake.wrappers.btop = {
    config,
    wlib,
    ...
  }: let
    inherit (wlib.types) file;
    toBtopConf = toKeyValue {
      mkKeyValue = mkKeyValueDefault {
        mkValueString = option:
          if isBool option
          then
            (
              if option
              then "True"
              else "False"
            )
          else if isString option
          then ''"${option}"''
          else toString option;
      } " = ";
    };
    baseBtopConf = import ./_config.nix {};
  in {
    imports = [wlib.modules.default];

    options =
      btopOptions
      // {
        "btop.conf" = mkOption {
          type = file config.pkgs;
          default.content = toBtopConf (baseBtopConf // config.extraSettings);
          visible = false;
        };
      };

    config.package = mkDefault (
      config.pkgs.btop.override {
        inherit (config) cudaSupport;
        inherit (config) rocmSupport;
      }
    );
    config.flags = {
      "--config" = toString config."btop.conf".path;
    };
  };

  # expose generic btop package without disks set
  perSystem = {pkgs, ...}: {
    packages.btop = (self.wrappers.btop.apply {inherit pkgs;}).wrapper;
  };

  flake.modules.nixos.default = {
    config,
    pkgs,
    ...
  }: {
    options.custom = {
      programs.btop =
        btopOptions
        // {
          # convenience option to add disks to btop
          disks = mkOption {
            type = listOf str;
            default = [];
            description = "List of disks to monitor in btop";
          };
        };
    };
    config = {
      nixpkgs.overlays = [
        (_: prev: {
          btop =
            (self.wrappers.btop.apply {
              pkgs = prev;
              extraSettings =
                {
                  color_theme = "nord";
                  disks_filter = concatStringsSep " " (
                    [
                      "/"
                      "/boot"
                      "/persist"
                    ]
                    ++ config.custom.programs.btop.disks
                  );
                }
                // config.custom.programs.btop.extraSettings;
            }).wrapper;
        })
      ];

      hj.packages = [
        pkgs.btop # overlay-ed above
      ];

      custom.programs.print-config = {
        btop =
          # sh
          ''moor --lang ini "${pkgs.btop.configuration.flags."--config".data}"'';
      };
    };
  };
}
