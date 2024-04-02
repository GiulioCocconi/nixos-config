# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, pkgs, ... }:
with lib;

pkgs.stdenvNoCC.mkDerivation {
  pname = "cormorantFonts";
  version = "unstable";

  src = fetchFromGithub {
    owner = "CatharsisFonts";
    repo = "Cormorant";
    rev = "87e695b322369c33e460725207b4561ae60c80cc";
    hash = "";
  };

  dontBuild = true;

  installPhase = ''
    INSTALL_DIR=$out/share/fonts/truetype/cormorant-fonts
    mkdir -p $INSTALL_DIR
    cp Cormorant/fonts/ttf/*.ttf $INSTALL_DIR

  '';

}
