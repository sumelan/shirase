{
  inputs,
  config,
  ...
}: let
  inherit (builtins) attrValues;
in {
  perSystem = {pkgs, ...}: let
    baseYaziConf = import ./_config.nix {inherit config pkgs;};
  in {
    packages.yazi = inputs.wrappers.wrappers.yazi.wrap (
      baseYaziConf
      // {
        inherit pkgs;
        extraPackages = attrValues {
          inherit (pkgs) ripdrag unar exiftool;
        };
      }
    );
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

    nixpkgs.overlays = [
      (_: _prev: {
        yazi = pkgs.custom.yazi.wrap {
          settings = {
            theme.flavor = {
              dark = "catppuccin-frappe";
            };
          };
          flavors = let
            src = pkgs.fetchFromGitHub {
              owner = "yazi-rs";
              repo = "flavors";
              rev = "06708015bfb53b169d99bb3907829f9175105d57";
              hash = "sha256-Gm6ThktOLUR+KDs6f3s1WCgrw2TOKQ4tolVvVdCxnCM=";
            };
          in {
            catppuccin-frappe = "${src}/catppuccin-frappe.yazi";
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

    custom.programs.print-config = let
      yaziDir = dirOf pkgs.yazi.configuration.constructFiles.yazi;
    in {
      yazi =
        # sh
        ''cat "${yaziDir}/yazi.toml" "${yaziDir}/theme.toml" "${yaziDir}/keymap.toml" | moor --lang toml'';
    };
  };
}
