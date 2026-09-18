# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, cogisysLib, config, options, ... }:
with lib;
with cogisysLib;

let
  cfg = config.cogisys.light;
in
{
  options.cogisys.light = {
    enable = mkEnableOption "light system";
    memory = mkBoolOpt cfg.enable "Set to true if system has little memory";
    storage = mkBoolOpt cfg.enable "Set to true if system has little storage space";
  };
}
