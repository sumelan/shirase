{config, ...}:
config.pkgs.writeText "theme.ron"
# ron
''
  #![enable(implicit_some)]
  #![enable(unwrap_newtypes)]
  #![enable(unwrap_variant_newtypes)]
  (
      default_album_art_path: None,
      format_tag_separator: " | ",
      browser_column_widths: [20, 45, 30],
      background_color: None,
      text_color: None,
      header_background_color: None,
      modal_background_color: None,
      modal_backdrop: false,
      preview_label_style: (fg: "blue", modifiers: "Bold"),
      preview_metadata_group_style: (fg: "magenta", modifiers: "Bold"),
      highlighted_item_style: (fg: "blue", modifiers: "Bold"),
      current_item_style: (fg: "black", bg: "blue", modifiers: "Bold"),
      borders_style: (fg: "blue"),
      highlight_border_style: (fg: "blue"),
      symbols: (
          song: "󰎇",
          dir: "󰀥",
          playlist: "",
          marker: "",
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
          symbols: ["", "█", "", "", "" ],
          track_style: None,
          elapsed_style: (fg: "blue"),
          thumb_style: (fg: "blue"),
          use_track_when_empty: true,
      ),

      scrollbar: (
          symbols: ["│", "█", "▲", "▼"],
          track_style: (),
          ends_style: (),
          thumb_style: (fg: "blue"),
      ),

      tab_bar: (
          active_style: (fg: "black", bg: "blue", modifiers: "Bold"),
          inactive_style: (),
      ),

      lyrics: (
          timestamp: false
      ),

      cava: (
          bar_symbols: ['▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'],

          inverted_bar_symbols: ['▔', '🮂', '🮃', '▀', '🮄', '🮅', '🮆', '█'],
          bar_width: 1,
          bar_spacing: 0,
          orientation: Horizontal,
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
              prop: (kind: Property(Title),
                  default: (kind: Text("Unknown"))
              ),
              label_prop: (kind: Text("Title test")),
              width: "50%",
          ),
          (
              prop: (kind: Property(Artist),
                  default: (kind: Text("Unknown Artist"))
              ),
              label_prop: (kind: Text("Artist")),
              width: "20%",
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

          direction: Horizontal,
          panes: [
              (
              size: "1",
              pane: Pane(Empty()),
              ),
          (
          size: "100%",
          pane: Split(
          direction: Vertical,
          panes: [
              (
                  size: "8",
                  pane: Split(
                      direction: Horizontal,
                      panes:[
                          (
                              borders: "TOP | BOTTOM | LEFT",
                              border_symbols: Thick,
                              size: "17",
                              pane: Pane(AlbumArt),
                          ),
                          (
                              size: "100%",
                              pane: Component("header_main"),
                          ),
                      ]
                  )
              ),
              (
                  pane: Pane(TabContent),
                  size: "100%",
              ),
          ]
      ),
      ),

      (
          size: "1",
          pane: Pane(Empty()),
      ),
          ]
      ),

      components: {

          // everything to the right of the album art
          "header_main": Split(
              direction: Vertical,
              panes: [
                  (
                      size: "4",
                      pane: Split(
                          direction: Horizontal,
                          panes: [
                              ( // empty panes for spacing on left and right of header
                                  size: "2",
                                  pane: Pane(Empty()),
                                  borders: "LEFT | TOP | BOTTOM",
                                  border_symbols: Inherited(parent: Thick, top_left: "┳", bottom_left: "┣"),
                              ),
                              (
                                  size: "25", // hardcoded length of left side of header
                                  pane: Component("header_left"),
                                  borders: "TOP | BOTTOM",
                                  border_symbols: Thick,
                              ),
                              (
                                  size: "100%", // middle section fills remaining header
                                  borders: "TOP | BOTTOM",
                                  border_symbols: Inherited(parent: Thick),
                                  pane: Component("header_center")
                              ),
                              (
                                  size: "25", // right side is the same size as left to center the title
                                  borders: "TOP | BOTTOM",
                                  border_symbols: Thick,
                                  pane: Component("header_right")
                              ),
                              (
                                  size: "2",
                                  pane: Pane(Empty()),
                                  borders: "RIGHT | TOP | BOTTOM",
                                  border_symbols: Inherited(parent: Thick, bottom_right: "┫"),
                                  border_style: (fg: "blue", modifiers: "Bold"),
                              ),
                          ]
                      )
                  ),
                  (
                      size: "2",
                      borders: "LEFT | RIGHT | BOTTOM",
                      border_symbols: Inherited(parent: Thick, bottom_left: "┣", bottom_right: "┫"),
                      pane: Component("progress_bar"),
                  ),
                  (
                      pane: Pane(Tabs),
                      borders: "RIGHT | LEFT | BOTTOM",
                      border_symbols: Inherited(parent: Thick, bottom_left: "┻"),
                      size: "2",
                  ),
              ]
          ),

          // breaking up the main header for easy configuration
          "header_left": Split(
              direction: Vertical,
              panes: [
                  (size: "1", pane: Component("album")),
                  (size: "1", pane: Component("state")),
              ]
          ),

          "header_center": Split(
              direction: Vertical,
              panes: [
                  (size: "1", pane: Component("artist")),
                  (size: "1", pane: Component("title")),
              ]
          ),

          "header_right": Split(
              direction: Vertical,
              panes: [
                  (size: "1", pane: Component("volume")),
                  (size: "1", pane: Component("states")),
              ]
          ),


          "album": Pane(Property(
              content: [
                  (kind: Text("󰀥 "), style: (fg: "blue", modifiers: "Bold")),
                  (kind: Property(Song(Album)), style: (fg: "blue", modifiers: "Bold"),
                      default: (kind: Text("Unknown"), style: (fg: "blue", modifiers: "Bold"))),
              ], align: Left, scroll_speed: 1
          )),


          "state": Pane(Property(
              content: [
                  (kind:
                      Property(Status(StateV2(
                          playing_label: "",
                          paused_label: "",
                          stopped_label: "",
                          stopped_style: (fg: "red", modifiers: "Bold")
                      ))),
                      style: (fg: "blue", modifiers: "Bold" )
                  ),
                  (kind: Text(" "), style: (fg: "blue", modifiers: "Bold")),
                  (kind: Property(Status(Elapsed)), style: (fg: "blue", modifiers: "Bold")),
                  (kind: Text(" / "), style: (fg: "blue", modifiers: "Bold")),
                  (kind: Property(Status(Duration)), style: (fg: "blue", modifiers: "Bold")),
                  (kind: Text(""), style: (fg: "blue", modifiers: "Bold")),
              ], align: Left,
          )),


          "artist": Pane(Property(
              content: [
                  (kind: Property(Song(Artist)), style: (fg: "white", modifiers: "Bold"),
                      default: (kind: Text("Unknown"), style: (fg: "white", modifiers: "Bold"))),
              ], align: Center, scroll_speed: 1
          )),


          "title": Pane(Property(
              content: [
                  (kind: Property(Song(Title)), style: (modifiers: "Bold"),
                      default: (kind: Text("No Song"), style: (modifiers: "Bold"))),
              ], align: Center, scroll_speed: 1
          )),

          // empty pane at start is for aligning everything to the right
          "volume": Split(
              direction: Horizontal,
              panes: [
                  (
                      size: "100%",
                      pane: Pane(Empty()),
                  ),
                  (
                      size: "12", // WARNING: hardcoded length to be the same size as the 'states' Pane
                      pane: Pane(Volume(kind: Slider(symbols: (filled: "─", thumb: "●", track: "─"))))
                  ),
                  (
                      size: "3",
                      pane: Pane(Property(
                          content: [
                              (kind: Property(Status(Volume)),style: (fg: "blue"))
                          ], align: Right
                      ))
                  ),
                  (
                      size: "1",
                      pane: Pane(Property(
                          content: [
                              (kind: Text("%"), style: (fg: "blue"))
                          ]
                      ))
                  ),
              ]
          ),


          "states": Pane(Property(
              content: [
                  (kind: Text("| "),style: (fg: "blue", modifiers: "Bold")),
                  (kind: Property(Status(SingleV2(
                      on_label: "󰎤",
                      off_label: "󰎦",
                      oneshot_label: "󰇊",
                      on_style: (fg: "blue", modifiers: "Bold"),
                      off_style: (fg: "dark_gray", modifiers: "Bold"),
                      oneshot_style: (fg: "blue", modifiers: "Bold"),
                  )))),
                  (kind: Text(" | "),style: (fg: "blue", modifiers: "Bold")),
                  (kind: Property(Status(RepeatV2(
                      on_label: "",
                      off_label: "",
                      on_style: (fg: "blue", modifiers: "Bold"),
                      off_style: (fg: "dark_gray", modifiers: "Bold"),
                  )))),
                  (kind: Text(" | "),style: (fg: "blue", modifiers: "Bold")),
                  (kind: Property(Status(RandomV2(
                      on_label: "",
                      off_label: "",
                      on_style: (fg: "blue", modifiers: "Bold"),
                      off_style: (fg: "dark_gray", modifiers: "Bold"),
                  )))),
                  (kind: Text(" | "),style: (fg: "blue", modifiers: "Bold")),
                  (kind: Property(Status(ConsumeV2(
                      on_label: "󰮯",
                      off_label: "󰮯",
                      oneshot_label: "󰮯󰇊",
                      on_style: (fg: "blue", modifiers: "Bold"),
                      off_style: (fg: "dark_gray", modifiers: "Bold"),
                      oneshot_style: (fg: "blue", modifiers: "Bold"),
                      )))),
                  (kind: Text(" |"), style: (fg: "blue", modifiers: "Bold")),
              ], align: Right
          )),


          // empty panes are for spacing on either side of the border
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
          ),

          // default components, unused in this layout
          "input_mode": Pane(Property(
              content: [
                  (kind: Transform(Replace(content: (kind: Property(Status(InputMode()))), replacements: [
                      (match: "Normal", replace: (kind: Text(" NORMAL "), style: (fg: "black", bg: "blue"))),
                      (match: "Insert", replace: (kind: Text(" INSERT "), style: (fg: "black", bg: "green"))),
                  ])))
              ], align: Center
          )),

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
      },
  )
''
