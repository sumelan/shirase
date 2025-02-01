{ ... }:
{
  custom = {
    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1200;
        workspaces = [
          1
          2
          3
          4
          5
          6
          7
          8
          9
          10
        ];
      }
    ];

    qtStyleFix = false;
    terminal.size = 12;

    easyEffects = {
      enable = true;
      preset = "Loudness+Autogain";
    };
    foliate.enable = true;
    thunderbird.enable = true;
  };
}
