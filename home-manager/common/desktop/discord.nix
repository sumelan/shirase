{pkgs, ...}: {
  home.packages = [pkgs.vesktop];

  programs.niri.settings = {
    binds = {
      "Mod+W" = {
        action.spawn = ["vesktop"];
        hotkey-overlay.title = ''<span foreground="#5E81AC">[Application]</span> Vesktop'';
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".config/vesktop"
    ];
  };
}
