{pkgs, ...}:
pkgs.writeText "nord.ron"
# ron
''
  #![enable(implicit_some)]
  #![enable(unwrap_newtypes)]
  #![enable(unwrap_variant_newtypes)]
  (
      default_album_art_path: None,
      draw_borders: true,
      show_song_table_header: false,
      symbols: (song: "󰝚 ", dir: " ", playlist: "󰲸 ", marker: "󰧂 ", ellipsis: "..."),
      progress_bar: (
          symbols: [" ", "󰇼", "", " ", " "],
          track_style: (fg: "#2E3440"),
          elapsed_style: (fg: "#ECEFF4", bg: "#2E3440"),
          thumb_style: (fg: "#ECEFF4", bg: "#2E3440"),
      ),
      scrollbar: (
          symbols: ["│", "█", "▲", "▼"],
          track_style: (),
          ends_style: (),
          thumb_style: (fg: "#60728A"),
      ),
      browser_column_widths: [20, 38, 42],
      text_color: "#E5E9F0",
      background_color: "#2E3440",
      header_background_color: "#242933",
      modal_background_color: None,
      tab_bar: (
          enabled: false,
          active_style: (fg: "#191D24", bg: "#A3BE8C", modifiers: "Bold"),
          inactive_style: (),
      ),
      borders_style: (fg: "#ECEFF4"),
      highlighted_item_style: (fg: "#EFD49F", modifiers: "Bold"),
      current_item_style: (fg: "#222630", bg: "#9FC6C5", modifiers: "Bold"),
      highlight_border_style: (fg: "#5E81AC"),
      song_table_format: [
          (
              prop: (kind: Property(Artist),
                  style: (fg: "#B1C89D"),
                  default: (kind: Text("Unknown"))
              ),
              width: "50%",
              alignment: Right,
          ),
          (
              prop: (kind: Text("-"),
                  style: (fg: "#ECEFF4", modifiers: "Dim"),
                  default: (kind: Text("Unknown"))
              ),
              width: "1",
              alignment: Center,
          ),
          (
              prop: (kind: Property(Title),
                  style: (fg: "#D79784"),
                  default: (kind: Text("No Song"))
              ),
              width: "50%",
              alignment: Left,
          ),
      ],
      layout: Split(
          direction: Vertical,
          panes: [
              (
                  pane: Pane(Header),
                  size: "2",
              ),
              (
                  pane: Pane(TabContent),
                  size: "100%",
              ),
              (
                  pane: Pane(ProgressBar),
                  size: "1",
              ),
          ],
      ),
      header: (
          rows: [
              (
                  left: [
                      (kind: Text(" ["), style: (fg: "#88C0D0", modifiers: "Dim")),
                      (kind: Property(Status(StateV2(
                          playing_label: "Playing",
                          paused_label: "Paused",
                          stopped_label: "Stopped",
                          playing_style: (fg: "#88C0D0", modifiers: "Bold"),
                          paused_style: (fg: "#88C0D0", modifiers: "Bold"),
                          stopped_style: (fg: "#88C0D0", modifiers: "Bold"))))
                      ),
                      (kind: Text("]"), style: (fg: "#88C0D0", modifiers: "Dim"))
                  ],
                  center: [
                      (kind: Property(Song(Title)), style: (fg: "#A3BE8C", modifiers: "Bold"),
                          default: (kind: Text("No Song"), style: (fg: "#A3BE8C", modifiers: "Bold"))
                      ),
                  ],
                  right: [
                      (kind: Text("Vol: "), style: (fg: "#81A1C1", modifiers: "Dim")),
                      (kind: Property(Status(Volume)), style: (fg: "#88C0D0", modifiers: "Bold")),
                      (kind: Text("% "), style: (fg: "#88C0D0", modifiers: "Dim"))
                  ]
              ),
              (
                  left: [
                      (kind: Text(" 󰚭 "), style: (fg: "#ECEFF4")),
                      (kind: Property(Status(Elapsed)), style: (fg: "#8FBCBB")),
                      (kind: Text(" / "), style: (fg: "#ECEFF4", modifiers: "Dim")),
                      (kind: Property(Status(Duration)), style: (fg: "#8FBCBB")),
                  ],
                  center: [
                      (kind: Text("󰳩 "), style: (fg: "#D08770", modifiers: "Bold")),
                      (kind: Text("- "), style: (fg: "#ECEFF4", modifiers: "Dim")),
                      (kind: Property(Song(Artist)), style: (fg: "#D08770", modifiers: "Bold"),
                          default: (kind: Text("Unknown"), style: (fg: "#D08770", modifiers: "Bold"))
                      ),
                  ],
                  right: [
                      (kind: Text("󰿈 "), style: (fg: "#ECEFF4")),
                      (kind: Property(Status(Bitrate)), style: (fg: "#8FBCBB")),
                      (kind: Text(" kbps "), style: (fg: "#ECEFF4", modifiers: "Dim")),
                  ]
              ),
          ],
      ),
  )
''
