{pkgs}: let
  runtimeEnv = pkgs.buildEnv {
    name = "bat-runtime-env";
    pathsToLink = ["/bin"];
    paths = with pkgs; [
      ov
    ];
  };
in
  pkgs.symlinkJoin {
    name = "bat";
    paths = with pkgs; [bat];
    nativeBuildInputs = with pkgs; [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/bat \
        --prefix PATH : ${runtimeEnv}/bin \
        --set BAT_PAGER "ov -F -H3" \
        --add-flags "--wrap=never" \
        --add-flags "--theme='Catppuccin Frappe'" \
        --add-flags "--style='header,grid,snip'"
    '';
    meta.mainProgram = "bat";
  }
