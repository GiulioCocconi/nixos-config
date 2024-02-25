{ lib, options, config, ... }:

with lib;
with lib.cogisys;

let
  cfg = config.cogisys.system.locale;
in
  {
    options.cogisys.system.locale = with types; {
      enable = mkBoolOpt false "Enable locale management.";
      timeZone = mkOpt types.str "Europe/Rome" "The timezone of the system.";
      locale = mkOpt types.str "en_US.UTF-8" "The locale of the system.";
      keyboardLayout = mkOpt types.str "it" "The keyboard layout of the system.";
    };

    config = mkIf cfg.enable {
      time.timeZone = cfg.timeZone;
      services.ntp.enable = true;

      i18n.defaultLocale = cfg.locale;
      console.keyMap = cfg.keyboardLayout;
    };
  }
