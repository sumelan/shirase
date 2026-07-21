{pkgs, ...}:
pkgs.writeText "theme.ron"
# ron
''
  #![enable(implicit_some)]
  #![enable(unwrap_newtypes)]
  #![enable(unwrap_variant_newtypes)]
  (
      default_album_art_path: None,
      format_tag_separator: " | ",
      browser_column_widths: [20, 38, 42],
      background_color: None,
      text_color: "white",
      header_background_color: None,
      modal_background_color: None,
      modal_backdrop: false,
      preview_label_style: (fg: "yellow"),
      preview_metadata_group_style: (fg: "yellow", modifiers: "Bold"),
      highlighted_item_style: (fg: "light_magenta", modifiers: "Bold"),
      current_item_style: (fg: "black", bg: "cyan", modifiers: "Bold"),
      borders_style: (fg: "yellow"),
      highlight_border_style: (fg: "cyan"),

      cava: (

  	orientation: Bottom,
  	bar_width: 2,
  	bar_symbols: ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'],

      bar_color: Gradient({
            0: "rgb(  255, 255,   255)",
           50: "rgb(  245, 169,   184)",
          100: "rgb(   91, 206,   250)",
      })

      ),

      symbols: (
          song: "󰎇",
          dir: "󱍚",
          playlist: "󰲸",
          marker: "|>",
          ellipsis: "...",
          song_style: None,
          dir_style: None,
          playlist_style: None,
      ),
      level_styles: (
          info: (fg: "blue", bg: "black"),
          warn: (fg: "yellow", bg: "black"),
          error: (fg: "red", bg: "black"),
          debug: (fg: "light_green", bg: "black"),
          trace: (fg: "magenta", bg: "black"),
      ),
      progress_bar: (
          symbols: ["─", "─", "─", "─", "─"],
          track_style: (fg: "black"),
          elapsed_style: (fg: "light_magenta"),
          thumb_style: (fg: "yellow"),
          use_track_when_empty: true,
      ),
      scrollbar: (
          symbols: ["│", "█", "▲", "▼"],
          track_style: (),
          ends_style: (),
          thumb_style: (fg: "yellow"),
      ),
      tab_bar: (
          active_style: (fg: "yellow", bg: "dark_gray"),
          inactive_style: (fg: "dark_gray"),
      ),
      lyrics: (
          timestamp: false,
  	horizontal_align: left,
      ),
      browser_song_format: [
          (
              kind: Group([
                  (kind: Property(Track)),
                  (kind: Text(" ")),
              ])
          ),
          (
              kind: Group([
                  (kind: Property(Artist)),
                  (kind: Text(" - ")),
                  (kind: Property(Title)),
              ]),
              default: (kind: Property(Filename))
          ),
      ],
      song_table_format: [
          (
              prop: (kind: Property(Artist),
                  default: (kind: Text("Unknown"))
              ),
              label_prop: (kind: Text("Artist")),
              width: "20%",
          ),
          (
              prop: (kind: Property(Title),
                  default: (kind: Text("Unknown"))
              ),
              label_prop: (kind: Text("Title")),
              width: "35%",
          ),
          (
              prop: (kind: Property(Album), style: (fg: "white"),
                  default: (kind: Text("Unknown Album"), style: (fg: "white"))
              ),
              label_prop: (kind: Text("Album")),
              width: "35%",
          ),
          (
              prop: (kind: Property(Duration),
                  default: (kind: Text("-"))
              ),
              label_prop: (kind: Text("Duration")),
              width: "4",
              alignment: Right,
          ),
      ],
      layout: Split(
          direction: Vertical,
          panes: [
              (
                  pane: Pane(TabContent),
                  size: "100%",
              ),
              (
                  size: "2",
                  pane: Split(
                      direction: Horizontal,
                      panes: [
                          (
                              size: "12",
                              borders: "TOP",
                              border_symbols: Inherited(parent: Rounded, top_right: "┬", bottom_right: "┴"),
                              pane: Component("input_mode")
                          ),
                          (
                              size: "100%",
                              borders: "TOP",
                              border_symbols: Rounded,
                              pane: Pane(Tabs),
                          ),

                      ]
                  ),
              ),
          ],
      ),
      components: {
          "state": Pane(Property(
              content: [
                  (kind: Text("["), style: (fg: "yellow", modifiers: "Bold")),
                  (kind: Property(Status(StateV2( ))), style: (fg: "yellow", modifiers: "Bold")),
                  (kind: Text("]"), style: (fg: "yellow", modifiers: "Bold")),
              ], align: Left,
          )),
          "title": Pane(Property(
              content: [
                  (kind: Property(Song(Title)), style: (modifiers: "Bold"),
                      default: (kind: Text("No Song"), style: (modifiers: "Bold"))),
              ], align: Left, scroll_speed: 1
          )),
          "volume": Split(
              direction: Horizontal,
              panes: [
                  (size: "1", pane: Pane(Property(content: [(kind: Text(""))]))),
                  (size: "100%", pane: Pane(Volume(kind: Slider(symbols: (filled: "─", thumb: "●", track: "─"))))),
                  (size: "3", pane: Pane(Property(content: [(kind: Property(Status(Volume)), style: (fg: "blue"))], align: Right))),
                  (size: "2", pane: Pane(Property(content: [(kind: Text("%"), style: (fg: "blue"))]))),
              ]
          ),
          "elapsed_and_bitrate": Pane(Property(
              content: [
                  (kind: Property(Status(Elapsed))),
                  (kind: Text(" / ")),
                  (kind: Property(Status(Duration))),
                  (kind: Group([
                      (kind: Text(" (")),
                      (kind: Property(Status(Bitrate))),
                      (kind: Text(" kbps)")),
                  ])),
              ],
              align: Left,
          )),
  	"album": Pane(Property(
              content: [
                  (kind: Property(Song(Album)), default: (kind: Text("Unknown Album"))),
              ], align: Left, scroll_speed: 1
          )),
          "artist_and_album": Pane(Property(
              content: [
                  (kind: Property(Song(Artist)), style: (fg: "magenta", modifiers: "Bold"),
                      default: (kind: Text("Unknown"), style: (fg: "yellow", modifiers: "Bold"))),
                  (kind: Text(" - ")),
                  (kind: Property(Song(Album)), default: (kind: Text("Unknown Album"))),
              ], align: Left, scroll_speed: 1
          )),
  	"artist": Pane(Property(
              content: [
                  (kind: Property(Song(Artist)), style: (fg: "yellow", modifiers: "Bold"),
                      default: (kind: Text("Unknown"), style: (fg: "yellow", modifiers: "Bold"))),
              ], align: Left, scroll_speed: 1
          )),
          "states": Split(
              direction: Horizontal,
              panes: [
                  (
                      size: "1",
                      pane: Pane(Empty())
                  ),
                  (
                      size: "100%",
                      pane: Pane(Property(content: [(kind: Property(Status(InputBuffer())), style: (fg: "blue"), align: Left)]))
                  ),
                  (
                      size: "6",
                      pane: Pane(Property(content: [
                          (kind: Text("["), style: (fg: "blue", modifiers: "Bold")),
                          (kind: Property(Status(RepeatV2(
                              on_label: "z",
                              off_label: "z",
                              on_style: (fg: "yellow", modifiers: "Bold"),
                              off_style: (fg: "blue", modifiers: "Dim"),
                          )))),
                          (kind: Property(Status(RandomV2(
                              on_label: "x",
                              off_label: "x",
                              on_style: (fg: "yellow", modifiers: "Bold"),
                              off_style: (fg: "blue", modifiers: "Dim"),
                          )))),
                          (kind: Property(Status(ConsumeV2(
                              on_label: "c",
                              off_label: "c",
                              oneshot_label: "c",
                              on_style: (fg: "yellow", modifiers: "Bold"),
                              off_style: (fg: "blue", modifiers: "Dim"),
                              oneshot_style: (fg: "red", modifiers: "Dim"),
                          )))),
                          (kind: Property(Status(SingleV2(
                              on_label: "v",
                              off_label: "v",
                              oneshot_label: "v",
                              on_style: (fg: "yellow", modifiers: "Bold"),
                              off_style: (fg: "blue", modifiers: "Dim"),
                              oneshot_style: (fg: "red", modifiers: "Bold"),
                          )))),
                          (kind: Text("]"), style: (fg: "blue", modifiers: "Bold")),
                          ],
                          align: Right
                      ))
                  ),
              ]
          ),
          "input_mode": Pane(Property(
              content: [
                  (kind: Transform(Replace(content: (kind: Property(Status(InputMode()))), replacements: [
                      (match: "Normal", replace: (kind: Text(" NORMAL "), style: (fg: "black", bg: "blue"))),
                      (match: "Insert", replace: (kind: Text(" INSERT "), style: (fg: "black", bg: "green"))),
                  ])))
              ], align: Center
          )),
          "header_left": Split(
              direction: Vertical,
              panes: [
                  (size: "1", pane: Component("state")),
                  (size: "1", pane: Component("elapsed_and_bitrate")),
              ]
          ),
          "header_center": Split(
              direction: Vertical,
              panes: [
                  (size: "1", pane: Component("title")),
                  (size: "1", pane: Component("artist")),
                  (size: "1", pane: Component("album")),
              ]
          ),
          "header_right": Split(
              direction: Horizontal,
              panes: [
                  (size: "100%", pane: Component("volume")),
                  (size: "7", pane: Component("states")),
              ]
          ),
          "progress_bar": Split(
              direction: Horizontal,
              panes: [
                  (
                      size: "1",
                      pane: Pane(Empty())
                  ),
                  (
                      size: "100%",
                      pane: Pane(ProgressBar)
                  ),
                  (
                      size: "1",
                      pane: Pane(Empty())
                  ),
              ]
          )
      },
  )
''
