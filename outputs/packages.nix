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
        pkgs.callPackage ../packages/nvim/${pkg}.nix {inherit self inputs pkgs;};
      shellPkg = pkg:
        pkgs.callPackage ../packages/shell/${pkg}.nix {inherit pkgs;};
      wrappedPkg = pkg:
        pkgs.callPackage ../packages/wrapped/${pkg}/${pkg}.nix {inherit self inputs pkgs functions;};
    in {
      nvim = nvimPkg "nvf";

      ns = shellPkg "ns";

      bat = wrappedPkg "bat";
      broot = wrappedPkg "broot";
      btop = wrappedPkg "btop";
      difftastic = wrappedPkg "difftastic";
      eza = wrappedPkg "eza";
      foot = wrappedPkg "foot";
      ghostty = wrappedPkg "ghostty";
      helix = wrappedPkg "helix";
      mango = wrappedPkg "mango";
      noctalia = wrappedPkg "noctalia";
      nushell = wrappedPkg "nushell";
      pqiv = wrappedPkg "pqiv";
      ripgrep = wrappedPkg "ripgrep";
      starship = wrappedPkg "starship";
      yt-dlp = wrappedPkg "yt-dlp";
      zathura = wrappedPkg "zathura";
    }
  )
