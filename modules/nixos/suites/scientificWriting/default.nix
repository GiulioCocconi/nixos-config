# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.suites.scientificWriting;
  gui = config.cogisys.system.gui;
  light = config.cogisys.light;
in
  {
    options.cogisys.suites.scientificWriting = with types; {
      enable = mkBoolOpt false "Enable scientific writing suite.";
    };

    config = mkIf cfg.enable {

      assertions = [(mkAssertionModule gui "GUI" "scientific writing")];

      environment.systemPackages = with pkgs; [
        (texlive.combine {
          inherit (texlive) scheme-medium
          standalone preview dvisvgm amsmath
          pgfplots;
        })
        asymptote
        libqalculate
        inkscape-with-extensions
        sioyek
        texmacs
      ] ++ optionals (!light.storage) [
        # sage
      ];
      cogisys.apps.chromium.addMathBookmarks = true;

    };
  }
