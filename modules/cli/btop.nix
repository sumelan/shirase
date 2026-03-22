{
  inputs,
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
      type = attrsOf (
        oneOf [
          bool
          float
          int
          str
        ]
      );
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
  flake.wrapperModules.btop = inputs.wrappers.lib.wrapModule (
    {
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
      baseBtopConf = {
        theme_background = false;
        cpu_single_graph = true;
        # base_10_sizes = true;
        show_gpu_info = "Off"; # don't show gpu info in cpu box
        show_disks = true;
        show_swap = true;
        swap_disk = false;
        use_fstab = false;
        only_physical = false;
        zfs_arc_cached = true;
        shown_boxes = "cpu mem net proc gpu0";
        gpu_mirror_graph = false;
      };
    in {
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
    }
  );

  # expose generic btop package without disks set
  perSystem = {pkgs, ...}: {
    packages.btop = (self.wrapperModules.btop.apply {inherit pkgs;}).wrapper;
  };

  flake.modules = {
    nixos.default = {config, ...}: {
      nixpkgs.overlays = [
        (_: prev: {
          # overlay so that security wrappers for xps can pick it up
          btop =
            (self.wrapperModules.btop.apply {
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
                    ++ config.hm.custom.programs.btop.disks
                  );
                }
                // config.hm.custom.programs.btop.extraSettings;
            }).wrapper;
        })
      ];
    };
    homeManager.default = {pkgs, ...}: {
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
        home = {
          packages = [
            pkgs.btop # overlay-ed above
          ];
        };
      };
    };
  };
}
