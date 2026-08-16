# Copyright (c) 2025 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, pkgs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.apps.mpv;
  gui = config.cogisys.system.gui;
in
{
  options.cogisys.apps.obs = with types; {
    enable = mkBoolOpt false "Enable obs (with heavy configuration & plugins).";
  };

  config = mkIf cfg.enable {
    assertions = [(mkAssertionModule gui "GUI" "OBS")];
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
    };
  };
}
