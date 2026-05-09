{pkgs, ...}: let
  address = "/run/mpd/socket";
  fifo = "/run/mpd/mpd.fifo";
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
        on_song_change: None,
        volume_step: 2,
        max_fps: 120,
        scrolloff: 0,
        wrap_navigation: true,
        enable_mouse: true,
        scroll_amount: 1,
        enable_config_hot_reload: false,
        enable_lyrics_hot_reload: false,
        status_update_interval_ms: 1000,
        rewind_to_start_sec: 5,
        keep_state_on_song_change: true,
        reflect_changes_to_playlist: false,
        select_current_song_on_change: true,
        ignore_leading_the: false,
        browser_song_sort: [Disc, Track, Artist, Title],
        directories_sort: SortFormat(group_by_type: true, reverse: false),
        auto_open_downloads: true,
        album_art: (
            method: Auto,
            max_size_px: (width: 1200, height: 1200),
            disabled_protocols: ["http://", "https://"],
            vertical_align: Center,
            horizontal_align: Center,
        ),
        cava: (
            framerate: 160, // default 60
            autosens: true, // default true
            sensitivity: 100, // default 100
            lower_cutoff_freq: 50, // not passed to cava if not provided
            higher_cutoff_freq: 16000, // not passed to cava if not provided
            input: (
                method: Fifo,
                source: "${fifo}",
                sample_rate: 44100,
                channels: 2,
                samble_bits: 16,
            ),
            smoothing: (
                noise_reduction: 0, // default 10
                monstercat: false, // default false
                waves: false, // default false
            ),
            output: (
                channels: stereo,
            ),
            // this is a list of floating point numbers thats directly passed to cava
            // they are passed in order that they are defined
            eq: []
        ),
        keybinds: (
            global: {
                "q":          Quit,
                "~":          ShowHelp,
                ":":          CommandMode,
                "oI":         ShowCurrentSongInfo,
                "oo":         ShowOutputs,
                "op":         ShowDecoders,
                "od":         ShowDownloads,
                "oP":         Partition(),
                "x":          ToggleRepeat,
                "c":          ToggleRandom,
                "v":          ToggleConsumeOnOff,
                "z":          ToggleSingleOnOff,
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
                "1":          SwitchToTab("Queue"),
                "2":          SwitchToTab("Albums"),
                "3":          SwitchToTab("Artists"),
                "4":          SwitchToTab("Playlists"),
                "5":          SwitchToTab("Directories"),
                "6":          SwitchToTab("Search"),
                "?":          SwitchToTab("Search"),
                "<C-u>":      Update,
                "<C-U>":      Rescan,
             // "R":          AddRandom,
            },
            navigation: {
                "<C-c>":      Close,
                "<Esc>":      Close,
                "<CR>":       Confirm,
                "e":          Up,
                "<Up>":       Up,
                "n":          Down,
                "<Down>":     Down,
                "h":          Left,
                "<Left>":     Left,
                "i":          Right,
                "<Right>":    Right,
                "<C-w>i":     PaneUp,
                "<C-Up>":     PaneUp,
                "<C-w>n":     PaneDown,
                "<C-Down>":   PaneDown,
                "<C-w>h":     PaneLeft,
                "<C-Left>":   PaneLeft,
                "<C-w>i":     PaneRight,
                "<C-Right>":  PaneRight,
                "E":          MoveUp,
                "N":          MoveDown,
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
                "k":          NextResult,
                "K":          PreviousResult,
                "a":          Add,
                "A":          AddAll,
                "r":          AddReplace,
                "R":          AddAllReplace,
                "D":          Delete,
                "<C-r>":      Rename,
                "l":          FocusInput,
                "oi":         ShowInfo,
                "<C-z>":      ContextMenu(),
                "<C-s>s":     Save(kind: Modal(all: false, duplicates_strategy: Ask)),
                "<C-s>a":     Save(kind: Modal(all: true, duplicates_strategy: Ask)),
             // "r":          Rate(),
            },
            queue: {
                "d":          Delete,
                "D":          DeleteAll,
                "<CR>":       Play,
                "Z":          JumpToCurrent,
                "C":          Shuffle,
            },
        ),
        search: (
            case_sensitive: false,
            ignore_diacritics: false,
            search_button: false,
            mode: Contains,
            tags: [
                (value: "any",         label: "Any Tag"),
                (value: "artist",      label: "Artist"),
                (value: "album",       label: "Album"),
                (value: "albumartist", label: "Album Artist"),
                (value: "title",       label: "Title"),
                (value: "filename",    label: "Filename"),
                // (value: "genre",       label: "Genre"),
            ],
        ),
        artists: (
            album_display_mode: SplitByDate,
            album_sort_by: Date,
            album_date_tags: [Date],
        ),
        tabs: [
            (
                name: "Queue",
                pane: Split(
                    direction: Vertical,
                    // borders: "ALL",
                    // border_symbols: Rounded, // bugged in current version, adding borders to inside objects as workaround
                    panes: [
                    (
                        pane: Pane(Queue),
                        size: "20",
                        borders: "ALL",
                        border_symbols: Inherited(parent: Thick, bottom_left: "┣", bottom_right: "┫"),
                    ),
                    (
                        pane: Pane(Cava),
                        size: "100%",
                        borders: "LEFT | RIGHT | BOTTOM",
                        border_symbols: Thick,
                    )
                        ],
                )
            ),
            (
                name: "Albums",
                borders: "ALL",
                border_symbols: Thick,
                pane: Split(
                    size: "100%",
                    direction: Vertical,
                    panes: [(pane: Pane(Albums), size: "100%", borders: "ALL", border_symbols: Thick)],
                )
            ),
            (
                name: "Artists",
                borders: "ALL",
                border_symbols: Thick,
                pane: Split(
                    size: "100%",
                    direction: Vertical,
                    panes: [(pane: Pane(AlbumArtists), size: "100%", borders: "ALL", border_symbols: Thick)],
                )
            ),
            (
                name: "Playlists",
                borders: "ALL",
                border_symbols: Thick,
                pane: Split(
                    size: "100%",
                    direction: Vertical,
                    panes: [(pane: Pane(Playlists), size: "100%", borders: "ALL", border_symbols: Thick)],
                )
            ),
            (
                name: "Directories",
                borders: "ALL",
                border_symbols: Thick,
                pane: Split(
                    size: "100%",
                    direction: Vertical,
                    panes: [(pane: Pane(Directories), size: "100%", borders: "ALL", border_symbols: Thick)],
                )
            ),
            (
                name: "Search",
                borders: "ALL",
                border_symbols: Thick,
                pane: Split(
                    size: "100%",
                    direction: Vertical,
                    panes: [(pane: Pane(Search), size: "100%", borders: "ALL", border_symbols: Thick)],
                )
            ),
        ],
    )
  ''
