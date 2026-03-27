{
  inputs,
  lib,
  self,
  ...
}: let
  inherit (builtins) listToAttrs;
  inherit (lib) mkOption mkDefault;
  inherit (lib.types) str;

  zathuraOptions = {
    extraSettings = mkOption {
      type = str;
      default = "";
      description = ''
        Extra settings to add to {file}`zathurarc` file.
        See <https://man.archlinux.org/man/zathurarc.5> for options.
      '';
    };
  };
in {
  flake.wrapperModules.zathura = inputs.wrappers.lib.wrapModule (
    {config, ...}: let
      zathuraConf = config.pkgs.writeTextFile {
        name = "zathurarc";
        destination = "/zathurarc"; # zathura expects a directory
        text = ''
          set adjust-open	"best-fit"
          set page-padding	"1"
          set recolor	"true"
          set statusbar-h-padding	"0"
          set statusbar-v-padding	"0"
          map D   toggle_page_mode
          map J   zoom out
          map K   zoom in
          map R   rotate
          map d   scroll half-down
          map i   recolor
          map p   print
          map r   reload
          map u   scroll half-up

          ${config.extraSettings}
        '';
      };
    in {
      options = zathuraOptions;

      config.package = mkDefault config.pkgs.zathura;
      config.flags = {
        "--config-dir" = toString zathuraConf;
      };
    }
  );

  perSystem = {pkgs, ...}: {
    packages.zathura = (self.wrapperModules.zathura.apply {inherit pkgs;}).wrapper;
  };

  flake.modules = {
    nixos.default = _: {
      options.custom = {
        programs.zathura = zathuraOptions;
      };

      config = {
        nixpkgs.overlays = [
          (_: prev: {
            zathura =
              (self.wrapperModules.zathura.apply {
                pkgs = prev;
                extraSettings = ''

                '';
              }).wrapper;
          })
        ];
      };
    };
    homeManager.default = {pkgs, ...}: {
      home.packages = [
        pkgs.zathura # overlay-ed above
      ];

      xdg.mimeApps = let
        value = "org.pwmt.zathura-pdf-mupdf.desktop";
        associations = listToAttrs (map (name: {
            inherit name value;
          }) [
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/png"
          ]);
      in {
        associations.removed = associations;
      };
      custom.programs.print-config = {
        zathura =
          # sh
          ''moor "${pkgs.zathura.flags."--config-dir"}/zathurarc"'';
      };
    };
  };
}
