_: {
  flake.modules.homeManager.krita = {pkgs, ...}: {
    home.packages = [pkgs.krita];
    # https://ironshark.org/posts/2023-01-artonlinux/
    xdg.configFile = {
      kritarc = {
        target = "kritarc";
        source = ./kritarc;
      };
      kritadisplayrc = {
        target = "kritadisplayrc";
        source = ./kritadisplayrc;
      };
      kritashortcutsrc = {
        target = "kritashortcutsrc";
        source = ./kritashortcutsrc;
      };
    };
    custom.persist.home = {
      directories = [
        ".local/share/krita"
      ];
    };
  };
}
