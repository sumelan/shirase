{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      bat = config.flake.custom.wrappers.mkBat {
        inherit pkgs;
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

  flake.custom.wrappers = {
    mkBat = {pkgs}:
      pkgs.symlinkJoin {
        name = "bat";
        paths = [pkgs.bat];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/bat \
            --add-flags "--theme base16" \
            --add-flags "--style grid"
        '';
        meta.mainProgram = "bat";
      };
  };
}
