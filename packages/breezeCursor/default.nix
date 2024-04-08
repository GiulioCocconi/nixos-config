# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation rec {
    name = "breezeCursor";
    version = "5.27.10";

    src = pkgs.fetchurl {
      url = "mirror://kde/stable/plasma/${version}/breeze-${version}.tar.xz";
      sha256 = "18h08w3ylgvhgcs63ai8airh59yb4kc0bz2zi6lm77fsa83rdg5y";
    };

    dontDropIconThemeCache = true;

    propagatedBuildInputs = [
      pkgs.hicolor-icon-theme
    ];

    installPhase = ''
      mkdir -p $out/share/icons/default
      cp -r cursors/Breeze/Breeze $out/share/icons
    '';
  }
