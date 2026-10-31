_: {
  greeterWidgetInstances = [
    {
      config = {
        autoPosition = true;
        colorMode = "default";
        customColor = "#ffffff";
        displayPreferences = ["all"];
        showAnalogNumbers = false;
        showAnalogSeconds = true;
        showDate = false;
        showDigitalSeconds = false;
        style = "expressive";
        syncPositionAcrossScreens = true;
        transparency = 0;
        twoTone = true;
        weight = 0;
      };
      enabled = true;
      id = "lock_clock";
      widgetType = "desktopClock";
    }
    {
      config = {
        colorMode = "default";
        customColor = "#ffffff";
        displayPreferences = ["all"];
        format = "short";
        syncPositionAcrossScreens = true;
      };
      enabled = true;
      id = "lock_date";
      widgetType = "lockDate";
    }
    {
      config = {
        displayPreferences = ["all"];
        passwordVisibility = "always";
        profileVisibility = "always";
        style = "expressive";
        syncPositionAcrossScreens = true;
      };
      enabled = true;
      id = "lock_auth";
      widgetType = "lockAuth";
    }
    {
      config = {
        background = true;
        displayPreferences = ["all"];
        showMediaPlayer = true;
        showWeather = true;
        syncPositionAcrossScreens = true;
      };
      enabled = true;
      id = "lock_status";
      widgetType = "lockStatus";
    }
    {
      config = {
        displayPreferences = ["all"];
        shape = "round";
        syncPositionAcrossScreens = true;
      };
      enabled = false;
      id = "lock_power";
      widgetType = "lockPower";
    }
    {
      config = {
        displayPreferences = ["all"];
        shape = "round";
        syncPositionAcrossScreens = true;
      };
      enabled = true;
      id = "lw_1793362440673_g0b8w719j";
      name = "Power";
      widgetType = "lockPower";
    }
    {
      config = {
        displayPreferences = ["all"];
        syncPositionAcrossScreens = true;
      };
      enabled = true;
      id = "greeter_session";
      widgetType = "greeterSession";
    }
  ];
}
