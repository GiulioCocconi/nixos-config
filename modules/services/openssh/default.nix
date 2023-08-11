{ lib, options, config, pkgs, ...}:
with lib;

let
  cfg = config.cogisys.services.openssh;
  networking = config.cogisys.system.networking;
in
  {
    options.cogisys.services.openssh = with types; {
      enable = mkEnableOption "openssh";
    };

    config = mkIf cfg.enable {

      assertions = [(mkAssertionModule networking "Networking" "openssh")];

      services.openssh = {
        enable = true;
        openFirewall = true;
      };

    };
  }
