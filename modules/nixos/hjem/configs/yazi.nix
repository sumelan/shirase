{
  self,
  lib,
  ...
}: {
  flake.modules.nixos.default = {pkgs, ...}: let
    inherit (self.packages.${pkgs.stdenv.hostPlatform.system}) yazi;
  in {
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

    environment.shellAliases = {
      lf = "yazi";
      y = "yazi";
    };

    hj.packages =
      [yazi]
      ++ (lib.mapAttrsToList (
          name: file:
            pkgs.writeShellApplication {
              name = "yazi-print-${name}";
              runtimeInputs = [pkgs.bat];
              text = ''
                YAZI_PATH=$(grep "export YAZI_CONFIG_HOME=" '${lib.getExe yazi}' | cut -d"'" -f2)
                moor --lang toml "$YAZI_PATH/${file}"
              '';
            }
        )
        {
          config = "yazi.toml";
          theme = "theme.toml";
          keymap = "keymap.toml";
        });
  };
}
