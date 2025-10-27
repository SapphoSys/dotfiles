{ lib, ... }:

{
  time = {
    timeZone = lib.mkDefault "Asia/Almaty";
    hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocales = lib.mkDefault [ "ru_RU.UTF-8/UTF-8" ];
  };
}