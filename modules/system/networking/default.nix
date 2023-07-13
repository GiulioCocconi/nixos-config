{ lib, options, config, ... }:
with lib;

let
  cfg = config.cogisys.system.networking;
in
{
  options.cogisys.system.networking = with types; {
    enable = mkBoolOpt false "Enable networking management.";
	wifi = { enable = mkBoolOpt false "Enable wifi connection."; };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      networking.networkmanager.enable = true;
      networking.firewall.enable = true;
    })
	(mkIf cfg.wifi.enable {
      networking = {
	    wireless.iwd.enable = true;
	    networkmanager.wifi.backend = "iwd";
	  };
	})
  ];

}
