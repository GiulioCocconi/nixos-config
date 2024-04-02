# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.apps.steam;
  gui = config.cogisys.system.gui;
in
{
  options.cogisys.apps.steam = with types; {
    enable = mkEnableOption "steam";
  };

  config = mkIf cfg.enable {
    assertions = [(mkAssertionModule gui "GUI" "Steam")];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; 
      dedicatedServer.openFirewall = true; 
    };

    hardware.opengl.driSupport32Bit = true; 
  };
}
