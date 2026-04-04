{
  inputs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  perSystem = {pkgs, ...}: {
    packages = {
      bat = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.bat;
        flags = {
          "--theme" = "base16";
          "--style" = "grid";
        };
      };
      # batman with completions
      batman = pkgs.bat-extras.batman.overrideAttrs (o: {
        postInstall =
          (o.postInstall or "")
          # sh
          + ''
            mkdir -p $out/share/bash-completion/completions
            echo 'complete -F _comp_cmd_man batman' > $out/share/bash-completion/completions/batman

            mkdir -p $out/share/fish/vendor_completions.d
            echo 'complete batman --wraps man' > $out/share/fish/vendor_completions.d/batman.fish

            mkdir -p $out/share/zsh/site-functions
            cat << EOF > $out/share/zsh/site-functions/_batman
            #compdef batman
            _man "$@"
            EOF
          '';
      });
    };
  };

  flake.modules.nixos.default = {pkgs, ...}: {
    nixpkgs.overlays = [
      (_: _prev: {
        inherit (pkgs.custom) bat;
      })
    ];

    programs = {
      # manually add the abbr so it doesn't get mangled by nix
      fish.interactiveShellInit =
        # fish
        ''
          abbr -a --position anywhere -- --help '--help | bat --plain --language=help'
        '';
    };

    hj.packages = [
      pkgs.bat # overlay-ed above
      pkgs.custom.batman
    ];

    custom.programs.print-config = {
      bat =
        # sh
        ''moor --lang sh "${getExe pkgs.bat}"'';
    };
  };
}
