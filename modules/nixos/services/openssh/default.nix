# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.services.openssh;
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

    };
  }
