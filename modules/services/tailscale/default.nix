{ lib, options, config, pkgs, ...}:
with lib;

let
  cfg = config.cogisys.services.tailscale;
in
{
  options.cogisys.services.tailscale = with types; {
    enable = mkBoolOpt false "Enable tailscale configuration.";
  };

  config = mkIf cfg.enable {

    services.tailscale = {
      enable = true;
    };

	networking.firewall = {
	  trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
      checkReversePath = "loose";
	};

  };
}
