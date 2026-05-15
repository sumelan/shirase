{config, ...}: let
  address = config.custom.services.mpd.settings.bind_to_address;
in {
  id = 677226551607033903;
  hosts = [address];

  format = {
    details = "$title";
    state = "On $album by $artist";
    timestamp = "both";
    large_image = "notes";
    small_image = "notes";
    large_text = "";
    small_text = "";
    display_type = "name";
  };
}
