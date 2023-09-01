{ lib, options, config,pkgs, ... }:
with lib;

let
  cfg = config.cogisys.system.printing;
in
  {
    options.cogisys.system.printing = with types; {
      enable = mkBoolOpt false "Enable printing.";
      wifi = { enable = mkBoolOpt wifi.enable "Enable wifi printing."; };
    };

    config = mkMerge [
      (mkIf cfg.enable {
        services.printing.enable = true;

        services.saned.enable = true;
        hardware.sane.enable = true;
        hardware.sane.openFirewall = true;

        environment.systemPackages = with pkgs; [ xsane ];
      })
      (mkIf (cfg.enable && cfg.wifi.enable) {
        services.avahi = {
          enable = true;
          nssmdns = true;
          openFirewall = true;
        };
      })
    ];
  }
