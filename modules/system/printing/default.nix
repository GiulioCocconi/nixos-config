{ lib, options, config, ... }:
with lib;

let
  cfg = config.cogisys.system.printing;
  wifi = config.cogisys.system.networking.wifi;

in
  {
    options.cogisys.system.printing = with types; {
      enable = mkBoolOpt false "Enable printing.";
      wifi = { enable = mkBoolOpt wifi.enable "Enable wifi printing."; };
    };

    config = mkMerge [
      (mkIf cfg.enable {
        services.printing.enable = true;
      })
      (mkIf (cfg.enable && cfg.wifi.enable) {
        assertions = [(mkAssertionModule wifi "WiFi" "WiFi printing")];

        services.avahi = {
          enable = true;
          nssmdns = true;
          openFirewall = true;
        };
      })
    ];
  }
