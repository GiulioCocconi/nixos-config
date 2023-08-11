{ lib, options, config, pkgs, ...}:
with lib;

let
  cfg = config.cogisys.services.tailscale;
  networking = config.cogisys.system.networking;
in
  {
    options.cogisys.services.tailscale = with types; {
      enable = mkEnableOption "tailscale";
    };

    config = mkIf cfg.enable {

      assertions = [(mkAssertionModule networking "Networking" "tailscale")];

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
