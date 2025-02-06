# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.services.openssh;
  terminalDefinition = {};
in
  {
    options.cogisys.services.openssh = with types; {
      enable = mkBoolOpt false "Enable openssh configuration.";
    };

    config = mkIf cfg.enable {

      services.openssh = {
        enable = true;
        openFirewall = true;
      };

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHjgpR2oQ0LIjJil4hmPhIsu1Ua6JKGUHEPyasfV/zIp"
      ];
      
      programs.ssh.startAgent = true;

    };
  }
