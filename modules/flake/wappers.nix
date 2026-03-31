_: {
  perSystem = _: {
    wrappers = {
      # wrappers.pkgs = pkgs; # choose a different `pkgs`
      control_type = "exclude"; # | "build" (default: "exclude")
      packages = {
        btop = true;
        foot = true;
        kitty = true;
        satty = true;
        zathura = true;
      };
    };
  };
}
