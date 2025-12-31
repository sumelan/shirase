_: {
  flake.modules.homeManager.foliate = {pkgs, ...}: {
    home.packages = [pkgs.foliate];

    custom = {
      persist.home.directories = [
        ".local/share/com.github.johnfactotum.Foliate"
      ];
      cache.home.directories = [
        ".cache/com.github.johnfactotum.Foliate"
      ];
    };
  };
}
