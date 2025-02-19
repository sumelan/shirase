{ config, ... }:
with config.lib.stylix.colors.withHashtag;
{
  xdg.configFile."rmpc/themes/custom.ron".text = ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
        default_album_art_path: None,
        draw_borders: true,
        show_song_table_header: false,
        symbols: (song: "", dir: "󱍙", marker: ""),
        progress_bar: (
            symbols: ["󰝤", "", " "],
            track_style: (fg: "${base01}"),
            elapsed_style: (fg: "${base0E}", bg: "${base01}"),
            thumb_style: (fg: "${base0E}", bg: "${base01}"),
        ),
        scrollbar: (
            symbols: ["│", "█", "▲", "▼"],
            track_style: (),
            ends_style: (),
            thumb_style: (fg: "${base07}"),
        ),
        browser_column_widths: [20, 38, 42],
        text_color: "${base05}",
        background_color: "${base00}",
        header_background_color: "${base01}",
        modal_background_color: None,
        tab_bar: (
            enabled: false,
            active_style: (fg: "black", bg: "${base0E}", modifiers: "Bold"),
            inactive_style: (),
        ),
        borders_style: (fg: "${base04}"),
        highlighted_item_style: (fg: "${base0E}", modifiers: "Bold"),
        current_item_style: (fg: "black", bg: "${base07}", modifiers: "Bold"),
        highlight_border_style: (fg: "${base07}"),
        song_table_format: [
            (
                prop: (kind: Property(Artist),
                    style: (fg: "${base07}"),
                    default: (kind: Text("Unknown"))
                ),
                width: "50%",
                alignment: Right,
            ),
            (
                prop: (kind: Text("-"),
                    style: (fg: "${base07}"),
                    default: (kind: Text("Unknown"))
                ),
                width: "1",
                alignment: Center,
            ),
            (
                prop: (kind: Property(Title),
                    style: (fg: "${base0C}"),
                    default: (kind: Text("Unknown"))
                ),
                width: "50%",
                alignment: Left,
            ),
        ],
        layout: Split(
            direction: Vertical,
            panes: [
                (
                    size: "2",
                    pane: Pane(Header),
                ),
                (
                    size: "100%",
                    pane: Split(
                        direction: Horizontal,
                        panes: [
                            (
                                size: "21",
                                pane:(TabContent),
                            ),
                            (
                                size: "100%",
                                pane: Pane(AlbumArt),
                            ),
                        ],
                    ),
                ),
                (
                    size: "1",
                    pane: Pane(ProgressBar),
                ),
            ],
        ),
        header: (
            rows: [
                (
                    left: [
                        (kind: Text("["), style: (fg: "${base07}", modifiers: "Bold")),
                        (kind: Property(Status(State)), style: (fg: "${base07}", modifiers: "Bold")),
                        (kind: Text("]"), style: (fg: "${base07}", modifiers: "Bold"))
                    ],
                    center: [
                        (kind: Property(Song(Artist)), style: (fg: "${base09}", modifiers: "Bold"),
                            default: (kind: Text("Unknown"), style: (fg: "${base09}", modifiers: "Bold"))
                        ),
                        (kind: Text(" - ")),
                        (kind: Property(Song(Title)), style: (fg: "${base0C}", modifiers: "Bold"),
                            default: (kind: Text("No Song"), style: (fg: "${base0C}", modifiers: "Bold"))
                        )
                    ],
                    right: [
                        (kind: Text("Vol: "), style: (fg: "${base07}", modifiers: "Bold")),
                        (kind: Property(Status(Volume)), style: (fg: "${base07}", modifiers: "Bold")),
                        (kind: Text("% "), style: (fg: "${base07}", modifiers: "Bold"))
                    ]
                )
            ],
        ),
    )
  '';
}
