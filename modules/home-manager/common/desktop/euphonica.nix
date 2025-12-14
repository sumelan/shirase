{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      cyanrip
      euphonica
      picard
      ;
  };

  custom.persist = {
    home.directories = [
      ".cache/euphonica"
    ];
  };
}
