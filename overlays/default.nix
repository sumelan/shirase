_: {
  nixpkgs.overlays = [
    # This one brings our custom packages from the 'pkgs' directory
    (final: _: import ../pkgs final.pkgs)
  ];
}
