# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, pkgs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.system.networking;
  rootFS = config.cogisys.system.boot.rootFilesystem;
in
  {
    options.cogisys.system.networking = with types; {
      enable = mkEnableOption "networking";
      wifi = { enable = mkEnableOption "wifi"; };
    };
    config = mkMerge [
      (mkIf cfg.enable {

        environment.systemPackages = with pkgs; [
          curlftpfs
          inetutils
        ];

        networking = {
          # networkmanager.enable = true;
          firewall.enable = mkDefault true;
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
          # networkmanager.wifi.backend = "iwd";
        };
      })
    ];
  }
