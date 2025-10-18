_: let
  base00 = "#323449";
  base01 = "#212337";
  base05 = "#ebfafa";
  base09 = "#f16c75";
  base0A = "#04d1f9";
  base0B = "#37f499";
  base0C = "#f7c67f";
  base0E = "#a48cf2";
  base0F = "#f1fc79";
in {
  xdg.configFile."rmpc/themes/custom.ron".text =
    # ron
    ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]
      (
          default_album_art_path: None,
          draw_borders: true,
          show_song_table_header: false,
          symbols: (song: "󰝚 ", dir: " ", playlist: "󰲸 ", marker: "󰧂", ellipsis: "..."),
          progress_bar: (
              symbols: ["󰇼", "󰇼", "", " ", " "],
              track_style: (fg: "${base00}"),
              elapsed_style: (fg: "${base0B}", bg: "${base01}"),
              thumb_style: (fg: "${base0B}", bg: "${base01}"),
          ),
          scrollbar: (
              symbols: ["│", "█", "▲", "▼"],
              track_style: (),
              ends_style: (),
              thumb_style: (fg: "${base05}"),
          ),
          browser_column_widths: [20, 38, 42],
          text_color: "${base05}",
          background_color: "${base01}",
          header_background_color: "${base00}",
          modal_background_color: None,
          tab_bar: (
              enabled: false,
              active_style: (fg: "black", bg: "${base0E}", modifiers: "Bold"),
              inactive_style: (),
          ),
          borders_style: (fg: "${base05}"),
          highlighted_item_style: (fg: "${base0A}", modifiers: "Bold"),
          current_item_style: (fg: "${base01}", bg: "${base0B}", modifiers: "Bold"),
          highlight_border_style: (fg: "${base0B}"),
          song_table_format: [
              (
                  prop: (kind: Property(Artist),
                      style: (fg: "${base09}"),
                      default: (kind: Text("Unknown"))
                  ),
                  width: "50%",
                  alignment: Right,
              ),
              (
                  prop: (kind: Text("-"),
                      style: (fg: "${base05}", modifiers: "Dim"),
                      default: (kind: Text("Unknown"))
                  ),
                  width: "1",
                  alignment: Center,
              ),
              (
                  prop: (kind: Property(Title),
                      style: (fg: "${base0E}"),
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
                          (kind: Text("["), style: (fg: "${base0B}", modifiers: "Dim")),
                          (kind: Property(Status(StateV2(
                              playing_label: "Playing",
                              paused_label: "Paused",
                              stopped_label: "Stopped",
                              playing_style: (fg: "${base0B}", modifiers: "Bold"),
                              paused_style: (fg: "${base0B}", modifiers: "Bold"),
                              stopped_style: (fg: "${base0B}", modifiers: "Bold"))))
                          ),
                          (kind: Text("]"), style: (fg: "${base0B}", modifiers: "Dim"))
                      ],
                      center: [
                          (kind: Property(Song(Title)), style: (fg: "${base0E}", modifiers: "Bold"),
                              default: (kind: Text("No Song"), style: (fg: "${base0E}", modifiers: "Bold"))
                          ),
                      ],
                      right: [
                          (kind: Text("Vol: "), style: (fg: "${base0B}", modifiers: "Dim")),
                          (kind: Property(Status(Volume)), style: (fg: "${base0B}", modifiers: "Bold")),
                          (kind: Text("% "), style: (fg: "${base0B}", modifiers: "Dim"))
                      ]
                  ),
                  (
                      left: [
                          (kind: Text(" 󰚭 "), style: (fg: "${base05}")),
                          (kind: Property(Status(Elapsed)), style: (fg: "${base0C}")),
                          (kind: Text(" / "), style: (fg: "${base0F}", modifiers: "Dim")),
                          (kind: Property(Status(Duration)), style: (fg: "${base0C}")),
                      ],
                      center: [
                          (kind: Text("󰳩 "), style: (fg: "${base09}", modifiers: "Bold")),
                          (kind: Text("- "), style: (fg: "${base05}", modifiers: "Dim")),
                          (kind: Property(Song(Artist)), style: (fg: "${base09}", modifiers: "Bold"),
                              default: (kind: Text("Unknown"), style: (fg: "${base09}", modifiers: "Bold"))
                          ),
                      ],
                      right: [
                          (kind: Text("󰿈 "), style: (fg: "${base05}")),
                          (kind: Property(Status(Bitrate)), style: (fg: "${base0C}")),
                          (kind: Text(" kbps "), style: (fg: "${base0F}", modifiers: "Dim")),
                      ]
                  ),
              ],
          ),
      )
    '';
}
