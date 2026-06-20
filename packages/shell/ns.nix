{
  perSystem = {pkgs, ...}: {
    packages.ns = pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = [pkgs.fzf pkgs.nix-search-tv];
      checkPhase = "";
      text = ''
        # Execute the script from the store path at runtime prevents IFD
        exec "${pkgs.nix-search-tv.src}/nixpkgs.sh" "$@"
      '';
    };
  };
}
