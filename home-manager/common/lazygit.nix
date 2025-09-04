{
  lib,
  config,
  ...
}: let
  inherit
    (lib)
    mkForce
    ;
  accent = "${config.lib.stylix.colors.withHashtag.base0E}";
  muted = "${config.lib.stylix.colors.withHashtag.base03}";
in {
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
