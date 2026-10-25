{pkgs, ...}:
pkgs.symlinkJoin {
  name = "bat";
  paths = with pkgs; [bat];
  nativeBuildInputs = with pkgs; [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/bat \
      --add-flags "--wrap=never" \
      --add-flags "--theme 'Catppuccin Frappe'" \
      --add-flags "--style numbers"
  '';
  meta.mainProgram = "bat";
}
