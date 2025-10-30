_: let
  # Black
  black0 = "#191D24";
  black1 = "#1E222A";
  black2 = "#222630";

  # Gray
  gray0 = "#242933";
  # Polar night
  gray1 = "#2E3440";
  gray2 = "#3B4252";
  gray3 = "#434C5E";
  gray4 = "#4C566A";
  # a light blue/gray
  # from @nightfox.nvim
  gray5 = "#60728A";

  # White
  # reduce_blue variant
  white0 = "#C0C8D8";
  # Snow storm
  white1 = "#D8DEE9";
  white2 = "#E5E9F0";
  white3 = "#ECEFF4";

  # Blue
  # Frost
  blue0 = "#5E81AC";
  blue1 = "#81A1C1";
  blue2 = "#88C0D0";

  # Cyan:
  cyan_base = "#8FBCBB";
  cyan_bright = "#9FC6C5";
  cyan_dim = "#80B3B2";

  # Aurora (from Nord theme)
  # Red
  red_base = "#BF616A";
  red_bright = "#C5727A";
  red_dim = "#B74E58";

  # Orange
  orange_base = "#D08770";
  orange_bright = "#D79784";
  orange_dim = "#CB775D";

  # Yellow
  yellow_base = "#EBCB8B";
  yellow_bright = "#EFD49F";
  yellow_dim = "#E7C173";

  # Green
  green_base = "#A3BE8C";
  green_bright = "#B1C89D";
  green_dim = "#97B67C";

  # Magenta
  magenta_base = "#B48EAD";
  magenta_bright = "#BE9DB8";
  magenta_dim = "#A97EA1";
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
          symbols: (song: "󰝚 ", dir: " ", playlist: "󰲸 ", marker: "󰧂 ", ellipsis: "..."),
          progress_bar: (
              symbols: ["󰇼", "󰇼", "", " ", " "],
              track_style: (fg: "${gray1}"),
              elapsed_style: (fg: "${white3}", bg: "${gray1}"),
              thumb_style: (fg: "${white3}", bg: "${gray1}"),
          ),
          scrollbar: (
              symbols: ["│", "█", "▲", "▼"],
              track_style: (),
              ends_style: (),
              thumb_style: (fg: "${gray5}"),
          ),
          browser_column_widths: [20, 38, 42],
          text_color: "${white2}",
          background_color: "${gray1}",
          header_background_color: "${gray0}",
          modal_background_color: None,
          tab_bar: (
              enabled: false,
              active_style: (fg: "${black0}", bg: "${green_base}", modifiers: "Bold"),
              inactive_style: (),
          ),
          borders_style: (fg: "${white3}"),
          highlighted_item_style: (fg: "${yellow_bright}", modifiers: "Bold"),
          current_item_style: (fg: "${black2}", bg: "${cyan_bright}", modifiers: "Bold"),
          highlight_border_style: (fg: "${blue0}"),
          song_table_format: [
              (
                  prop: (kind: Property(Artist),
                      style: (fg: "${green_bright}"),
                      default: (kind: Text("Unknown"))
                  ),
                  width: "50%",
                  alignment: Right,
              ),
              (
                  prop: (kind: Text("-"),
                      style: (fg: "${white3}", modifiers: "Dim"),
                      default: (kind: Text("Unknown"))
                  ),
                  width: "1",
                  alignment: Center,
              ),
              (
                  prop: (kind: Property(Title),
                      style: (fg: "${orange_bright}"),
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
                          (kind: Text(" ["), style: (fg: "${blue2}", modifiers: "Dim")),
                          (kind: Property(Status(StateV2(
                              playing_label: "Playing",
                              paused_label: "Paused",
                              stopped_label: "Stopped",
                              playing_style: (fg: "${blue2}", modifiers: "Bold"),
                              paused_style: (fg: "${blue2}", modifiers: "Bold"),
                              stopped_style: (fg: "${blue2}", modifiers: "Bold"))))
                          ),
                          (kind: Text("]"), style: (fg: "${blue2}", modifiers: "Dim"))
                      ],
                      center: [
                          (kind: Property(Song(Title)), style: (fg: "${green_base}", modifiers: "Bold"),
                              default: (kind: Text("No Song"), style: (fg: "${green_base}", modifiers: "Bold"))
                          ),
                      ],
                      right: [
                          (kind: Text("Vol: "), style: (fg: "${blue1}", modifiers: "Dim")),
                          (kind: Property(Status(Volume)), style: (fg: "${blue2}", modifiers: "Bold")),
                          (kind: Text("% "), style: (fg: "${blue2}", modifiers: "Dim"))
                      ]
                  ),
                  (
                      left: [
                          (kind: Text(" 󰚭 "), style: (fg: "${white3}")),
                          (kind: Property(Status(Elapsed)), style: (fg: "${cyan_base}")),
                          (kind: Text(" / "), style: (fg: "${white3}", modifiers: "Dim")),
                          (kind: Property(Status(Duration)), style: (fg: "${cyan_base}")),
                      ],
                      center: [
                          (kind: Text("󰳩 "), style: (fg: "${orange_base}", modifiers: "Bold")),
                          (kind: Text("- "), style: (fg: "${white3}", modifiers: "Dim")),
                          (kind: Property(Song(Artist)), style: (fg: "${orange_base}", modifiers: "Bold"),
                              default: (kind: Text("Unknown"), style: (fg: "${orange_base}", modifiers: "Bold"))
                          ),
                      ],
                      right: [
                          (kind: Text("󰿈 "), style: (fg: "${white3}")),
                          (kind: Property(Status(Bitrate)), style: (fg: "${cyan_base}")),
                          (kind: Text(" kbps "), style: (fg: "${white3}", modifiers: "Dim")),
                      ]
                  ),
              ],
          ),
      )
    '';
}
