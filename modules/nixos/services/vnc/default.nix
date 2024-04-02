# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, config, options, pkgs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.services.vnc;
  networking = config.cogisys.system.networking;
in
  {
    options.cogisys.services.vnc = with types; {
      enable = mkEnableOption "vnc";
    };

    config = mkIf cfg.enable {
      # assertions = [(mkAssertionModule "networking" "vnc")];
      services.x2goserver.enable = true;
    };
  }
