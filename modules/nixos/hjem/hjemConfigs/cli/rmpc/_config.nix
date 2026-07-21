{
  pkgs,
  cache,
  lyrics,
  ...
}: let
  address = "/run/user/1000/mpd/socket";
  fifo = "/run/user/1000/mpd/mpd.fifo";
in
  pkgs.writeText "config.ron"
  # ron
  ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
        address: "${address}",
        password: None,
        theme: Some("custom"),
        cache_dir: "${cache}/rmpc",
        on_song_change: None,
        volume_step: 5,
        max_fps: 60,
        scrolloff: 0,
        wrap_navigation: true,
        enable_mouse: true,
        scroll_amount: 1,
        lyrics_dir: "${lyrics}",
        enable_config_hot_reload: true,
        enable_lyrics_hot_reload: true,
        status_update_interval_ms: 1000,
        rewind_to_start_sec: None,
        keep_state_on_song_change: true,
        reflect_changes_to_playlist: false,
        select_current_song_on_change: false,
        ignore_leading_the: true,
        browser_song_sort: [Disc, Track, Artist, Title],
        directories_sort: SortFormat(group_by_type: true, reverse: false),
        auto_open_downloads: true,
        album_art: (
            method: Auto,
            max_size_px: (width: 800, height: 800),
            disabled_protocols: ["http://", "https://"],
            vertical_align: Bottom,
            horizontal_align: Left,
        ),



        cava: (
           framerate: 60, // default 60
           autosens: true, // default true
           sensitivity: 100, // default 100
           lower_cutoff_freq: 50, // not passed to cava if not provided
           higher_cutoff_freq: 10000, // not passed to cava if not provided
           input: (
               method: Fifo,
               source: "${fifo}",
               sample_rate: 48000,
               channels: 2,
               sample_bits: 16,
           ),
           smoothing: (
               noise_reduction: 77, // default 77
               monstercat: true, // default false
               waves: false, // default false
           ),
           // this is a list of floating point numbers thats directly passed to cava
           // they are passed in order that they are defined
           eq: []
        ),

        keybinds: (
            global: {
                "q":          Quit,
                "?":          ShowHelp,
                ":":          CommandMode,
                "oI":         ShowCurrentSongInfo,
                "oo":         ShowOutputs,
                "op":         ShowDecoders,
                "od":         ShowDownloads,
                "oP":         Partition(),
                "z":          ToggleRepeat,
                "x":          ToggleRandom,
                "c":          ToggleConsume,
                "v":          ToggleSingle,
                "p":          TogglePause,
                "s":          Stop,
                ">":          NextTrack,
                "<":          PreviousTrack,
                "f":          SeekForward,
                "b":          SeekBack,
                ".":          VolumeUp,
                ",":          VolumeDown,
                "<Tab>":      NextTab,
                "gt":         NextTab,
                "<S-Tab>":    PreviousTab,
                "gT":         PreviousTab,
                "1":          SwitchToTab("Playing"),
                "2":          SwitchToTab("Queue"),
                "3":          SwitchToTab("Browser"),
                "4":          SwitchToTab("Playlists"),
                "5":          SwitchToTab("Search"),
                "<C-u>":      Update,
                "<C-U>":      Rescan,
                "R":          AddRandom,
            },
            navigation: {
                "<C-c>":      Close,
                "<Esc>":      Close,
                "<CR>":       Confirm,
                "k":          Up,
                "<Up>":       Up,
                "j":          Down,
                "<Down>":     Down,
                "h":          Left,
                "<Left>":     Left,
                "l":          Right,
                "<Right>":    Right,
                "<C-w>k":     PaneUp,
                "<C-Up>":     PaneUp,
                "<C-w>j":     PaneDown,
                "<C-Down>":   PaneDown,
                "<C-w>h":     PaneLeft,
                "<C-Left>":   PaneLeft,
                "<C-w>l":     PaneRight,
                "<C-Right>":  PaneRight,
                "K":          MoveUp,
                "J":          MoveDown,
                "<C-u>":      UpHalf,
                "<C-d>":      DownHalf,
                "<C-b>":      PageUp,
                "<PageUp>":   PageUp,
                "<C-f>":      PageDown,
                "<PageDown>": PageDown,
                "gg":         Top,
                "G":          Bottom,
                "<Space>":    Select,
                "<C-Space>":  InvertSelection,
                "/":          EnterSearch,
                "n":          NextResult,
                "N":          PreviousResult,
                "a":          Add,
                "A":          AddAll,
                "D":          Delete,
                "<C-r>":      Rename,
                "i":          FocusInput,
                "oi":         ShowInfo,
                "<C-z>":      ContextMenu(),
                "<C-s>s":     Save(kind: Modal(all: false, duplicates_strategy: Ask)),
                "<C-s>a":     Save(kind: Modal(all: true, duplicates_strategy: Ask)),
                "r":          Rate(),
            },
            queue: {
                "d":          Delete,
                "D":          DeleteAll,
                "<CR>":       Play,
                "C":          JumpToCurrent,
                "X":          Shuffle,
            },
        ),
        search: (
            case_sensitive: false,
            ignore_diacritics: true,
            search_button: true,
            mode: Contains,
            tags: [
                (value: "any",         label: "Any Tag"),
                (value: "artist",      label: "Artist"),
                (value: "album",       label: "Album"),
                (value: "albumartist", label: "Album Artist"),
                (value: "title",       label: "Title"),
                (value: "filename",    label: "Filename"),
                (value: "genre",       label: "Genre"),
            ],
        ),
        artists: (
    	case_sensitive: false,
            album_display_mode: SplitByDate,
            album_sort_by: Date,
            album_date_tags: [Date],
        ),
        tabs: [

    	(
    	    borders: "NONE",
    	    name: "Playing",
    	    size: "100%",
    	    pane: Split(
    		direction: Horizontal,
    		panes: [
    		   (
    		   	size: "45",
    			borders: "NONE",
    			pane: Split(
    				direction: Vertical,
    				panes: [
    				(size: "100%", borders: "NONE", pane: Pane(Empty())),
    		   		(
    					size: "22",
    					borders: "NONE",
    					pane: Pane(AlbumArt)
    				),

    			])
    		   ),

    		   (size: "2", borders: "NONE", pane: Pane(Empty())),
    		   (
    			size: "100%",
    			borders: "NONE",
    			pane: Split(
    				direction: Vertical,
    				panes: [
    				   (
    			    	   size: "2",
    				   borders: "NONE",
    				   pane: Split(
    				   	direction: Horizontal,
    					panes: [
    				   (size: "100%", borders: "NONE", pane: Pane(Empty())),
    				   (size: "30", borders: "NONE", pane: Component("header_right")),
    					]
    					),
    				   ),
    				   (size: "100%", borders: "NONE", pane: Pane(Empty())),

    				   (
    					size: "4", borders: "NONE", pane: Pane(Lyrics),
    				   ),

    		                   (size: "1", borders: "NONE", pane: Pane(Empty())),
    				   (
    					size: "4", borders: "NONE", pane: Component("header_center"),
    				   ),
    				   (
    					size: "1", borders: "NONE", pane: Pane(Empty()),
    				   ),
    				   (
    					size: "6",
    					borders: "NONE",
    					pane: Split(
    						direction: Horizontal,
    						panes: [
    						   (
    							size: "0", borders: "NONE", pane: Pane(Empty()),
    				   		   ),
    						   (
    							size: "100%",
    							borders: "NONE",
    							pane: Pane(Cava),
    				   		   ),
    						   (
    							size: "1", borders: "NONE", pane: Pane(Empty()),
    				   		   ),
    						   ])
    				   ),
    						   (
    							size: "0", borders: "NONE", pane: Pane(Empty()),
    				   		   ),
    				   				   (
    				   size: "2",
    				   borders: "NONE",

    		   		   pane: Component("progress_bar")
    				   ),

    				]

    				)
    		   ),
    		])
    	),


    	(
    	    name: "Queue",
    	    size:  "100%",
    	    pane: Pane(Queue),        ),

            (
                name: "Browser",
                borders: "NONE",
                border_symbols: Rounded,
                pane: Split(
                    size: "100%",
                    direction: Vertical,
                    panes: [(pane: Pane(Browser(root_tag: "AlbumArtist")), size: "100%", borders: "NONE", border_symbols: Rounded)],
                )
            ),
            (
                name: "Playlists",
                borders: "ALL",
                border_symbols: Rounded,
                pane: Split(
                    size: "100%",
                    direction: Vertical,
                    panes: [(pane: Pane(Playlists), size: "100%", borders: "NONE", border_symbols: Rounded)],
                )
            ),
            (
                name: "Search",
                borders: "ALL",
                border_symbols: Rounded,
                pane: Split(
                    size: "100%",
                    direction: Vertical,
                    panes: [(pane: Pane(Search), size: "100%", borders: "NONE", border_symbols: Rounded)],
                )
            ),
        ],

        )
  ''
