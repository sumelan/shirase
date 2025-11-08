{pkgs, ...}: {
  home.packages = [
    (pkgs.discord.override {withMoonlight = true;})
  ];

  programs = {
    moonlight = {
      enable = true;
      configs.stable = {
        extensions = {
          moonbase = true;
          disableSentry = true;
          noTrack = true;
          noHideToken = true;
          # Add line numbers, see what language is used, expanded ANSI support, uncap file preview limits
          betterCodeblocks = true;
          # Reverts App back to Bot and adds webhook tags
          betterTags = true;
          # Makes the upload button single click to upload and right click for other options
          betterUploadButton = true;
          # Bypass copyright blocks, description, block ads and trackers
          # (works with Watch Together)
          betterEmbedsYT = true;
          # Allows you to remove any button from the chat bar
          cleanChatBar = {
            enabled = true;
            config = {
              removedButtons = [
                "gift"
                "gif"
                "sticker"
                "activity"
              ];
            };
          };
          # Removes analytics parameters from urls when sending messages
          clearUrls = true;
          # Add role colors to places missing them
          colorConsistency = true;
          # Allows WebP images to be copied
          copyWebp = true;
          # Load custom styles into Discord
          moonlight-css = {
            enabled = true;
            # Files/folders/URLs to load CSS form, Paths can be prefixed with `@light`or `@dark` to only laod on that theme
            config = {
              paths = [
                "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-nord.theme.css"
              ];
              themeAttributes = true;
            };
          };
          # Replaces the `Search with Google` context menu item with a custom search engine
          customSearchEngine = {
            enabled = true;
            config = {
              label = "Search with Kagi";
              # `%s` gets replaced with the serach query
              url = "https://kagi.com/search?q=%s";
            };
          };
          # Allows double clicking messages to reply or edit
          doubleClickActions = true;
          # Displays the filename (or full URL) of image attachments on hover
          imgTitle = true;
          # Pan and zoom in image popups, plus some other tools
          imageViewer = true;
          # Only opens the channel when clicking on a voice channel forcing you to click the Join  Voice button to actually connect
          manuallyJoinVoice = true;
          # A library for adding new markdown rules
          markdown = true;
          # Show the online and total member count of each server
          memberCount = true;
          # Show avaters on user mentions
          mentionAvatars = true;
          # Ruby (Furigana) support for Discord
          ruby = true;
          # Render codeblcoks with the sjis language as normal text in a ShiftJIS supported font
          shiftjis = true;
          # Add a translate button to context menus when you select text. Interacts with the Google Translate API
          translateText = {
            enabled = true;
            config = {
              translateTo = "ja";
            };
          };
          # Show avatars and role colors in the typing indicator
          typingTweaks = true;
        };
        repositories = [
          "https://moonlight-mod.github.io/extensions-dist/repo.json"
        ];
      };
    };

    niri.settings = {
      binds = {
        "Mod+D" = {
          action.spawn = ["discord"];
          hotkey-overlay.title = ''<span foreground="#B1C89D">[  Moonlight]</span> Discord Client'';
        };
      };
    };
  };

  custom.persist = {
    home.directories = [
      ".config/discord"
      # installed extensions
      ".config/moonlight-mod/extensions"
    ];
  };
}
