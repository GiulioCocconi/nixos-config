{ lib, options, config, ... }:
with lib;

let
  cfg = config.cogisys.system.printing;
  wifi = config.cogisys.system.networking.wifi;

in
{
  options.cogisys.system.printing = with types; {
    enable = mkBoolOpt false "Enable printing.";
	wifi = { enable = mkBoolOpt false "Enable wifi printing."; };
  };

  config = mkMerge [
    (mkIf cfg.enable {
	  services.printing.enable = true;
	 })
	 (mkIf cfg.wifi.enable {
       assertions = [{
	     assertion = wifi.enable;
		 message = "Wifi must be enabled in order to print with it!";
	   }];

	   services.avahi = {
	     enable = true;
		 nssmdns = true;
		 openFirewall = true;
	   };
	 })
  ];
}
