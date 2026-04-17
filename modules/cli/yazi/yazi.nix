{
  config,
  lib,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) recursiveUpdate getExe;
in {
  perSystem = {pkgs, ...}: let
    baseYaziConf = import ./_config.nix {inherit config pkgs;};
  in {
    packages.yazi =
      (pkgs.yazi.override {
        inherit (baseYaziConf) initLua plugins settings;
        extraPackages = attrValues {
          inherit
            (pkgs)
            ripdrag # Drag and Drop utilty written in Rust and GTK4
            unar
            exiftool
            ;
        };
      }).overrideAttrs
      {
        passthru = {
          inherit (baseYaziConf) settings;
        };
      };
  };

  flake.modules.nixos.default = {pkgs, ...}: {
    # shell integrations
    programs = {
      bash.interactiveShellInit =
        # sh
        ''
          function yy() {
            local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
            yazi "$@" --cwd-file="$tmp"
            if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
              builtin cd -- "$cwd"
            fi
            rm -f -- "$tmp"
          }
        '';

      fish.interactiveShellInit =
        # fish
        ''
          function yy
            set -l tmp (mktemp -t "yazi-cwd.XXXXX")
            command yazi $argv --cwd-file="$tmp"
            if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
              builtin cd -- "$cwd"
            end
            rm -f -- "$tmp"
          end
        '';
    };

    nixpkgs.overlays = let
      inherit (pkgs.custom) yazi;
    in [
      (_: _prev: {
        yazi = yazi.override {
          settings = recursiveUpdate yazi.passthru.settings {
            theme.flavor = {
              dark = "everforest-medium";
            };
          };
          flavors = {
            everforest-medium = pkgs.fetchFromGitHub {
              owner = "sumelan";
              repo = "everforest-medium.yazi";
              rev = "45a125e7753558e70423eb80057acf515e56518d";
              hash = "sha256-VOIo77m1uO2w43xWqucZxAdj8xQZzrMtNH2z7U10+x8=";
            };
          };
        };
      })
    ];

    environment.shellAliases = {
      lf = "yazi";
      y = "yazi";
    };

    hj.packages = [
      pkgs.yazi # overlay-ed above
    ];

    custom.programs.print-config =
      # yazi uses makeWrapper directly, no choice but to parse the wrapper
      let
        catYaziPath = path:
        # sh
        ''
          YAZI_PATH=$(grep "export YAZI_CONFIG_HOME=" '${getExe pkgs.yazi}' | cut -d"'" -f2)

          moor "$YAZI_PATH/${path}"
        '';
      in {
        yazi = catYaziPath "yazi.toml";
        yazi-theme = catYaziPath "theme.toml";
        yazi-keymap = catYaziPath "keymap.toml";
      };
  };
}
