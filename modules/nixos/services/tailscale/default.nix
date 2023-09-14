{ lib, options, config, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.services.tailscale;
  networking = config.cogisys.system.networking;
in
  {
    options.cogisys.services.tailscale = with types; {
      enable = mkBoolOpt false "Enable tailscale configuration.";
    };

    config = mkIf cfg.enable {

      assertions = [(mkAssertionModule networking "networking" "tailscale")];

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
