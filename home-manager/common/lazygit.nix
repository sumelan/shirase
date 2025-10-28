{lib, ...}: let
  inherit (lib) mkForce;
  accent = "#D08770";
  muted = "#60728A";
in {
  home.shellAliases = {
    gg = "lazygit";
  };

  programs.lazygit = {
    enable = true;
    settings = mkForce {
      disableStartupPopups = true;
      notARepository = "skip";
      promptToReturnFromSubprocess = false;
      update.method = "never";
      git = {
        commit.signOff = true;
        parseEmoji = true;
      };
      gui = {
        theme = {
          activeBorderColor = [
            accent
            "bold"
          ];
          inactiveBorderColor = [muted];
        };
        showListFooter = false;
        showRandomTip = false;
        showCommandLog = false;
        showBottomLine = false;
        nerdFontsVersion = "3";
      };
    };
  };
}
