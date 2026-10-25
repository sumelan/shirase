{pkgs, ...}: {
  environment.systemPackages = [pkgs.fzf];

  programs = {
    bash.interactiveShellInit =
      # sh
      ''
        if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
          eval "$(${pkgs.lib.getExe pkgs.fzf} --bash)"
        fi
      '';
  };
}
