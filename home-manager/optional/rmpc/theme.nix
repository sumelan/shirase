{ config, ... }:
with config.lib.stylix.colors.withHashtag;
{
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
              track_style: (fg: "${base01}"),
              elapsed_style: (fg: "${base0D}", bg: "${base00}"),
              thumb_style: (fg: "${base0D}", bg: "${base00}"),
          ),
          scrollbar: (
              symbols: ["│", "█", "▲", "▼"],
              track_style: (),
              ends_style: (),
              thumb_style: (fg: "${base04}"),
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
          highlighted_item_style: (fg: "${base0A}", modifiers: "Bold"),
          current_item_style: (fg: "${base00}", bg: "${base0D}", modifiers: "Bold"),
          highlight_border_style: (fg: "${base0D}"),
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
                          (kind: Text("["), style: (fg: "${base0D}", modifiers: "Bold")),
                          (kind: Property(Status(StateV2(
                              playing_label: "Playing",
                              paused_label: "Paused",
                              stopped_label: "Stopped",
                              playing_style: (fg: "${base0D}", modifiers: "Bold"),
                              paused_style: (fg: "${base0D}", modifiers: "Bold"),
                              stopped_style: (fg: "${base0D}", modifiers: "Bold"))))
                          ),
                          (kind: Text("]"), style: (fg: "${base0D}", modifiers: "Bold"))
                      ],
                      center: [
                          (kind: Text(" "), style: (fg: "${base09}", modifiers: "Bold")),
                          (kind: Text("- "), style: (fg: "${base05}", modifiers: "Dim")),
                          (kind: Property(Song(Title)), style: (fg: "${base0E}", modifiers: "Bold"),
                              default: (kind: Text("No Song"), style: (fg: "${base0E}", modifiers: "Bold"))
                          ),
                      ],
                      right: [
                          (kind: Text("Vol: "), style: (fg: "${base0D}", modifiers: "Bold")),
                          (kind: Property(Status(Volume)), style: (fg: "${base0D}", modifiers: "Bold")),
                          (kind: Text("% "), style: (fg: "${base0D}", modifiers: "Bold"))
                      ]
                  ),
                  (
                      left: [
                          (kind: Text("󱫝 "), style: (fg: "${base05}")),
                          (kind: Property(Status(Elapsed)), style: (fg: "${base0F}")),
                          (kind: Text(" / "), style: (fg: "${base0F}", modifiers: "Dim")),
                          (kind: Property(Status(Duration)), style: (fg: "${base0F}")),
                          (kind: Text(" {"), style: (fg: "${base0F}", modifiers: "Dim")),
                          (kind: Property(Status(Bitrate)), style: (fg: "${base0F}")),
                          (kind: Text(" kbps"), style: (fg: "${base0F}", modifiers: "Dim")),
                          (kind: Text("}"), style: (fg: "${base0F}", modifiers: "Dim"))
                      ],
                      center: [
                          (kind: Text("󰳩 "), style: (fg: "${base09}", modifiers: "Bold")),
                          (kind: Text("- "), style: (fg: "${base05}", modifiers: "Dim")),
                          (kind: Property(Song(Artist)), style: (fg: "${base07}", modifiers: "Bold"),
                              default: (kind: Text("Unknown"), style: (fg: "${base07}", modifiers: "Bold"))
                          ),
                      ],
                      right: [
                          (
                              kind: Property(Widget(States(
                                  active_style: (fg: "${base0F}", modifiers: "Bold"),
                                  separator_style: (fg: "${base0F}")))
                              ),
                              style: (fg: "${base0F}", modifiers: "Dim")
                          ),
                      ]
                  ),
              ],
          ),
      )
    '';
}
