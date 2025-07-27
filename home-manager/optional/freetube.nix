{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.custom = {
    freetube.enable = lib.mkEnableOption "freetube";
  };

  config = lib.mkIf config.custom.freetube.enable {
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
          baseTheme = "gruvboxDark";
          mainColor = "GruvboxDarkAqua";
          secColor = "GruvboxDarkAqua";
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

      niri.settings = {
        binds = {
          "Mod+Y" = lib.custom.niri.openApp {
            app = pkgs.freetube;
            args = "--enable-wayland-ime --wayland-text-input-version=3";
          };
        };
        window-rules = lib.singleton {
          matches = lib.singleton {
            title = "^(ピクチャー イン ピクチャー)$";
          };
          open-floating = true;
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
