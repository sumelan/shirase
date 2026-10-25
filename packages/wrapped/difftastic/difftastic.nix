{pkgs, ...}:
pkgs.symlinkJoin {
  name = "difft";
  paths = with pkgs; [difftastic];
  nativeBuildInputs = with pkgs; [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/difft \
      --add-flags "--background dark"
  '';
  meta.mainProgram = "difft";
}
