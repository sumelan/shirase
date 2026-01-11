{config, ...}: let
  inherit
    (config.flake.lib.colors)
    black0
    black2
    gray0
    gray1
    gray5
    white0
    white1
    white2
    white3
    blue0
    blue1
    blue2
    yellow_bright
    cyan_base
    cyan_bright
    red_bright
    green_base
    green_bright
    orange_base
    orange_bright
    magenta_bright
    ;
in {
  flake.modules.homeManager = {
    rmpc = {
      xdg.configFile."rmpc/themes/nord.ron".text =
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
    };

    youtube-tui = {pkgs, ...}: {
      xdg.configFile."youtube-tui/appearance.yml".source = (pkgs.formats.yaml {}).generate "appearance" {
        borders = "Rounded";
        colors = {
          text = white0;
          text_special = white3;
          text_secondary = white2;
          text_error = red_bright;
          outline = white1;
          outline_selected = blue2;
          outline_hover = red_bright;
          outline_secondary = yellow_bright;
          message_outline = "#FF7F00";
          message_error_outline = red_bright;
          message_success_outline = green_bright;
          item_info = {
            tag = gray5;
            title = blue2;
            description = gray5;
            author = green_bright;
            viewcount = yellow_bright;
            length = cyan_bright;
            published = magenta_bright;
            video_count = "#838DFF";
            sub_count = "#65FFBA";
            likes = "#C8FF81";
            genre = "#FF75D7";
            page_turner = gray5;
          };
        };
      };
    };
  };
}
