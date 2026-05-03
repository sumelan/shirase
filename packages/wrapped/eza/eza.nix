{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      eza = config.flake.custom.wrappers.mkEza {
        inherit pkgs;
      };
      eza-tree = pkgs.writeShellApplication {
        name = "tree";
        runtimeInputs = [pkgs.eza];
        text =
          # sh
          ''
            if [ $# -eq 0 ]; then
                echo "No arguments provided"
                exit 1
            fi

            # Get all arguments except the last one
            args=("''${@:1:$#-1}")

            # Get the last argument
            last_arg="''${!#}"

            if [ -L "$last_arg" ]; then
                set -- "''${args[@]}" "$(readlink -f "$last_arg")"
            else
                # If it's not a symlink, keep the original arguments
                set -- "$@"
            fi

            # run eza with resolved arguments
            eza -la --git-ignore --tree --hyperlink --level 5 "$@"
          '';
      };
    };
  };

  flake.custom.wrappers = {
    mkEza = {pkgs}:
      pkgs.symlinkJoin {
        name = "eza";
        paths = [pkgs.eza];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/eza \
            --add-flags "--icons" \
            --add-flags "--group-directories-first" \
            --add-flags "--header" \
            --add-flags "--octal-permissions" \
            --add-flags "--hyperlink"
        '';
        meta.mainProgram = "eza";
      };
  };
}
