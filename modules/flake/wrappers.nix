_: {
  perSystem = _: {
    wrappers = {
      # wrappers.pkgs = pkgs; # choose a different `pkgs`
      control_type = "exclude"; # | "build" (default: "exclude")
      packages = {
        foot = true;
        ghostty = true;
        kitty = true;
        satty = true;
        pqiv = true;
      };
    };
  };
}
