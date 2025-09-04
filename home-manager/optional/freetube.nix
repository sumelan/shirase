{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
  inherit
    (lib.custom.niri)
    openApp
    ;
in {
  options.custom = {
    freetube.enable = mkEnableOption "freetube";
  };

  config = mkIf config.custom.freetube.enable {
    programs = {
      freetube = {
        enable = true;
        settings = {
          # common
          settingsSectionSortEnabled = false;
          checkForBlogPosts = false;
          checkForUpdates = false;
          openDeepLinksInNewWindow = true;
          generalAutoLoadMorePaginatedItemsEnabled = true;
          quickBookmarkTargetPlaylistId = "favorites";

          # theme
          barColor = true;
          hideLabelsSideBar = true;
          hideHeaderLogo = true;
          expandSideBar = false;
          baseTheme = "nordic";
          mainColor = "CatppuccinFrappeRed";
          secColor = "CatppuccinFrappeSky";
          bounds = {
            x = 0;
            y = 0;
            width = 1200;
            height = 1920;
            maximized = false;
            fullScreen = false;
          };

          # player
          playNextVideo = false;
          enableScreenshot = false;
          hideChannelHome = false;
          hideChannelCommunity = true;
          hideChannelPodcasts = true;
          hideChannelShorts = true;
          hideCommentPhotos = true;
          hideRecommendedVideos = true;
          hideSubscriptionsCommunity = true;
          hideSubscriptionsShorts = true;
          hideFeaturedChannels = true;
          hideTrendingVideos = true;
          hidePopularVideos = true;
          hidePlaylists = false;

          # sponsorblock
          useSponsorBlock = true;
          useDeArrowThumbnails = true;
          useDeArrowTitles = true;
        };
      };

      niri.settings.binds = {
        "Mod+Y" = openApp {
          app = pkgs.freetube;
        };
      };
    };

    custom.persist = {
      home.directories = [
        ".config/FreeTube"
      ];
    };
  };
}
