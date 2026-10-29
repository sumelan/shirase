{
  self,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs.lib) genAttrs;
  forAll = genAttrs [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
  forLinux = genAttrs [
    "x86_64-linux"
    "aarch64-linux"
  ];
  nixpkgsFor = forAll (
    system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
  );
in
  forLinux (
    system: let
      pkgs = nixpkgsFor.${system};
      functions = import ../lib/functions/functions.nix {inherit pkgs;};

      nvimPkg = pkg:
        pkgs.callPackage ../packages/nvim/${pkg}.nix;
      shellPkg = pkg:
        pkgs.callPackage ../packages/shell/${pkg}.nix;
      wrappedPkg = pkg:
        pkgs.callPackage ../packages/wrapped/${pkg}/${pkg}.nix;
    in {
      nvim = nvimPkg "nvf" {inherit self inputs pkgs;};

      ns = shellPkg "ns" {inherit pkgs;};

      bat = wrappedPkg "bat" {inherit pkgs;};
      broot = wrappedPkg "broot" {inherit pkgs functions;};
      btop = wrappedPkg "btop" {inherit pkgs functions;};
      difftastic = wrappedPkg "difftastic" {inherit pkgs;};
      eza = wrappedPkg "eza" {inherit pkgs;};
      foot = wrappedPkg "foot" {inherit self pkgs functions;};
      ghostty = wrappedPkg "ghostty" {inherit self pkgs functions;};
      helix = wrappedPkg "helix" {inherit self pkgs functions;};
      noctalia = wrappedPkg "noctalia" {inherit pkgs;};
      nushell = wrappedPkg "nushell" {inherit self inputs pkgs functions;};
      pqiv = wrappedPkg "pqiv" {inherit pkgs functions;};
      ripgrep = wrappedPkg "ripgrep" {inherit pkgs functions;};
      starship = wrappedPkg "starship" {inherit pkgs functions;};
      yt-dlp = wrappedPkg "yt-dlp" {inherit pkgs functions;};
      zathura = wrappedPkg "zathura" {inherit pkgs functions;};
    }
  )
