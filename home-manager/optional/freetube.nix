{
  lib,
  config,
  ...
}:
{
  options.custom = {
    freetube.enable = lib.mkEnableOption "freetube";
  };

  config = lib.mkIf config.custom.freetube.enable {
    programs.freetube = {
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
        baseTheme = "catppuccinFrappe";
        mainColor = "CatppuccinFrappeRed";
        secColor = "CatppuccinFrappeTeal";
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

    custom.persist = {
      home.directories = [
        ".config/FreeTube"
      ];
    };
  };
}
