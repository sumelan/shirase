{pkgs}:
pkgs.symlinkJoin {
  name = "moor";
  paths = with pkgs; [moor];
  nativeBuildInputs = with pkgs; [makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/moor \
      --set MOOR '--statusbar=bold --style=catppuccin-frappe'
  '';
  meta.mainProgram = "moor";
}
