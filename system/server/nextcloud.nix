{
  lib,
  config,
  pkgs,
  ...
}: 
{
  options.custom = with lib; {
    nc.enable = mkEnableOption "Enable nextcloud";
  };

  config = lib.mkIf config.custom.nc.enable {
    services.nextcloud = {
      enable = true;
      hostName = "nextcloud.${config.custom.server.nginx.domain}";
      ## Need to manually increment with every major upgrade.
      package = pkgs.nextcloud30;
      # Let NixOS install and configure the database automatically.
      database.createLocally = true;
      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;
      # Increase the maximum file upload size to avoid problems uploading vidoes.
      maxUploadSize = "16G";
      https = true;
      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit calendar contacts mail notes tasks;
      };
      settings = {
        maintenance_window_start = "1";
        log_type = "file";
        default_phone_region = "JP";
        enabledPreviewProviders = [
          "OC\\Preview\\TXT"
          "OC\\Preview\\MarkDown"
          "OC\\Preview\\OpenDocument"
          "OC\\Preview\\PDF"
          "OC\\Preview\\MSOffice2023"
          "OC\\Preview\\MSOfficeDoc"
          "OC\\Preview\\Image"
          "OC\\Preview\\Photoshop"
          "OC\\Preview\\TIFF"
          "OC\\Preview\\SVG"
          "OC\\Preview\\Font"
          "OC\\Preview\\MP3"
          "OC\\Preview\\Movie"
          "OC\\Preview\\MKV"
          "OC\\Preview\\MP4"
          "OC\\Preview\\AVI"
          "OC\\Preview\\Krita"
        ];
      };
      config = {
        dbtype = "pgsql";
        adminuser = "sumelan";
        adminpassFile = config.age.secrets.nextcloud.path;
      };
      phpOptions = {
        "opcache.interned_strings_buffer" = "16";
      };
    };
  };
}
