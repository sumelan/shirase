{pkgs, ...}:
pkgs.symlinkJoin {
  name = "eza";
  paths = with pkgs; [eza];
  nativeBuildInputs = with pkgs; [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/eza \
      --add-flags "--icons" \
      --add-flags "--group-directories-first" \
      --add-flags "--header" \
      --add-flags "--octal-permissions" \
      --add-flags "--hyperlink"
  '';
  meta.mainProgram = "eza";
}
