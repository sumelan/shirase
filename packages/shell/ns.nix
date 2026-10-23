{pkgs}:
pkgs.writeShellApplication {
  name = "ns";
  runtimeInputs = with pkgs; [
    fzf
    nix-search-tv
  ];
  checkPhase = "";
  text = ''
    # Execute the script from the store path at runtime prevents IFD
    exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"
  '';
}
