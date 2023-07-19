{ lib, options, config, pkgs, ... }:
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


      # Fixes issue https://github.com/NixOS/nixpkgs/issues/195777
      system.activationScripts = with pkgs; {
        restart-udev = "${systemd}/bin/systemctl restart systemd-udev-trigger.service";
      };

    })
	(mkIf (cfg.enable && cfg.wifi.enable) {
      networking = {
	    wireless.iwd.enable = true;
	    networkmanager.wifi.backend = "iwd";
	  };
	})
  ];
}
