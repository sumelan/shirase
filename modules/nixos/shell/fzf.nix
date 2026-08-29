{lib, ...}: {
  flake.modules.nixos.default = {pkgs, ...}: {
    environment.systemPackages = [pkgs.fzf];

    programs = {
      bash.interactiveShellInit =
        # sh
        ''
          if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
            eval "$(${lib.getExe pkgs.fzf} --bash)"
          fi
        '';
    };
  };
}
