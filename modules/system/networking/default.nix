{ lib, options, config, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.system.networking;
  rootFS = config.cogisys.system.boot.rootFilesystem;
in
  {
    options.cogisys.system.networking = with types; {
<<<<<<< HEAD
      enable = mkEnableOption "networking";
      wifi = { enable = mkEnableOption "wifi"; };
=======
      enable = mkBoolOpt false "Enable networking management.";
      wifi = { enable = mkBoolOpt false "Enable wifi connection."; };
>>>>>>> parent of 2a5cb23 (Using mkEnableOption in all modules)
    };
    config = mkMerge [
      (mkIf cfg.enable {
        networking = {
          networkmanager.enable = true;
          firewall.enable = true;
          hostId = if (rootFS == "zfs") then
            builtins.substring 0 8 (builtins.readFile /etc/machine-id)
            else null;
        };


        # Fixes https://github.com/NixOS/nixpkgs/issues/195777
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
