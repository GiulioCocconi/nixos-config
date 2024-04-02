# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, config, options, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.virtualmachine;
in
{
  options.cogisys.virtualmachine = with types; {
    enable = mkBoolOpt false "Is the system a virtualmachine?";
    software = mkOpt (enum ["virtualbox" "vmware"]) "virtualbox" "Software used for virtualization.";
  };

  config = mkIf cfg.enable {
      cogisys = {
        light = enabled;
        system = {
          printing.enable = mkForce false;
          networking.wifi.enable = mkForce false;
          boot.mode = "legacy";
        };
      };

      virtualisation.${cfg.software}.guest.enable = true;

    };
}
